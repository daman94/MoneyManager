//
//  PieChartViewController.m
//  MoneyManager
//
//  Created by Daman Saroa on 10/07/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import "PieChartViewController.h"

@interface PieChartViewController ()

@property(strong,nonatomic) CPTGraphHostingView *hostView;
@property(strong,nonatomic) CPTTheme *selectedTheme;

@property(strong,nonatomic) ExpenseDBEdit *expenseDBEdit;
@property(strong,nonatomic) NSMutableArray *expenseArray;

@end

@implementation PieChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTabBar {
    if ([self init]) {
        self.title = @"Graphs";
        self.tabBarItem.image = [UIImage imageNamed:@"pieChart.png"];
        self.navigationItem.title = @"Graphical View";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.expenseDBEdit = [[ExpenseDBEdit alloc] init];
    self.expenseArray = [[NSMutableArray alloc] init];
    self.expenseArray = [self.expenseDBEdit selectExpensesWithDifferentCategories];
    [self initPlot];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self initPlot];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initPlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.expenseArray count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    if (CPTPieChartFieldSliceWidth == fieldEnum)
    {
        Expense *expense = [[Expense alloc] init];
        expense = [self.expenseArray objectAtIndex:index];
        
        //converting string to nsnumber
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *number = [NSNumber numberWithFloat:expense.amount];
        
        return number;
    }

    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    // 1 - Define label text style
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText)
    {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    
    // 2 - Calculate total value
    Expense *expense = [[Expense alloc] init];
    NSDecimalNumber *number;
    NSDecimalNumber *expenseSum = [NSDecimalNumber zero];
    
    for (int i=0; i < [_expenseArray count]; i++)
    {
        expense = [self.expenseArray objectAtIndex:i];
        number = [[NSDecimalNumber alloc] initWithFloat:expense.amount];
        expenseSum = [expenseSum decimalNumberByAdding:number];
    }
    
    //3. Calculate percentage Value
    expense = [self.expenseArray objectAtIndex:index];
    NSDecimalNumber *expenseAmount = [[NSDecimalNumber alloc] initWithFloat:expense.amount];
    NSDecimalNumber *percent = [expenseAmount decimalNumberByDividingBy:expenseSum];
    
    // 4 - Set up display label
    NSString *labelValue =[NSString stringWithFormat:@"Rs. %0.0f (%0.1f %%)", [expenseAmount floatValue],([percent floatValue] * 100.00f)];
    
    // 5 - Create and return layer with label text
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
}

-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    if (index < [self.expenseArray count])
    {
        Expense *expense = [[Expense alloc] init];
        expense = [self.expenseArray objectAtIndex:index];
        return expense.category;
    }
    return @"N/A";
}

#pragma mark - UIActionSheetDelegate methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
}

-(void) initPlot {
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
    // 1 - Set up view frame
    CGRect parentRect = self.view.bounds;
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    parentRect = CGRectMake(0,
                            0 ,
                            screenSize.size.width,
                            screenSize.size.height - 64.0);
    // 2 - Create host view
    CPTGraphHostingView *graphHostView = [[CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView = graphHostView;
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
    
}

-(void)configureGraph {
    // 1 - Create and initialize graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 120.0f;
    graph.axisSet = nil;
    
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    
    // 3 - Configure title
    NSString *title = @"Expenses";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    
    // 4 - Set theme
    self.selectedTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:self.selectedTheme];
    
}

-(void)configureChart {
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = MIN(self.hostView.bounds.size.width/2 - 80,self.hostView.bounds.size.height/2 - 80);
    
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    // 4 - Add chart to graph    
    [graph addPlot:pieChart];
    
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index;
{
    CPTFill *color;
    
    if (index == 0)
    {
        color = [CPTFill fillWithColor:[CPTColor cyanColor]];
    }
    else if (index == 1)
    {
        color = [CPTFill fillWithColor:[UIColor colorWithRed:69.0f/255.0f green:121.0f/255.0f blue:252.0/255.0f alpha:1.0f]];
    }
    else if (index == 2)
    {
        color = [CPTFill fillWithColor:[UIColor colorWithRed:51.0f/255.0f green:187.0f/255.0f blue:50.0/255.0f alpha:1.0f]];
    }
    else if (index == 3)
    {
        color = [CPTFill fillWithColor:[UIColor colorWithRed:194.0f/255.0f green:244.0f/255.0f blue:21.0/255.0f alpha:1.0f]];
    }
    else if (index == 4)
    {
        color = [CPTFill fillWithColor:[UIColor colorWithRed:249.0f/255.0f green:255.0f/255.0f blue:7.0/255.0f alpha:1.0f]];
    }
    else if (index == 5)
    {
        color = [CPTFill fillWithColor:[UIColor colorWithRed:255.0f/255.0f green:189.0f/255.0f blue:0.0/255.0f alpha:1.0f]];
    }
    else if (index == 6)
    {
        color = [CPTFill fillWithColor:[UIColor colorWithRed:255.0f/255.0f green:9.0f/255.0f blue:38.0/255.0f alpha:1.0f]];
    }
    else if (index == 7)
    {
        color = [CPTFill fillWithColor:[UIColor colorWithRed:155.0f/255.0f green:0.0f/255.0f blue:177.0/255.0f alpha:1.0f]];
    }
    
    return color;
}

-(void)configureLegend {
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    // 3 - Configure legend
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    // 4 - Add legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorRight;
    CGFloat legendPadding = -(self.view.bounds.size.width / 30);
    graph.legendDisplacement = CGPointMake(legendPadding, -100.0);
}

//- (ExpenseDBEdit *) expenseDBEdit {
//    if (!_expenseDBEdit) {
//        _expenseDBEdit = [[ExpenseDBEdit alloc] init];
//    }
//    return _expenseDBEdit;
//}
//
//- (NSMutableArray *) expenseArray {
//    if (!_expenseArray) {
//        _expenseArray = [[NSMutableArray alloc] init];
//        _expenseArray = [self.expenseDBEdit selectExpensesWithDifferentCategories];
//    }
//    return _expenseArray;
//}


@end
