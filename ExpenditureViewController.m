//
//  ExpenditureViewController.m
//  MoneyManager
//
//  Created by Daman Saroa on 05/07/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import "ExpenditureViewController.h"
#import "IXIColors.h"
#import "AppDelegate.h"

//Numerics

CGFloat const myLabelXDirection = 30.0;
CGFloat const myLabelYDirection = 60.0;
CGFloat const myLabelWidth = 120.0;
CGFloat const myLabelHeight = 30.0;
CGFloat const myLabelDIff = 15.0;
CGFloat const my2LabelXDirection = 170.0;
CGFloat const rowWidth = 35.0;
CGFloat const rowHeight = 35.0;

@interface ExpenditureViewController ()

@end

@implementation ExpenditureViewController

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
        self.title = @"View Expenses";
        self.tabBarItem.image = [UIImage imageNamed:@"Expenses.png"];
        self.navigationItem.title = @"Money Manager";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupDefaultTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ExpenseDBEdit *expenseDBEdit = [[ExpenseDBEdit alloc]init];
    [expenseDBEdit prepareDatabase];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self setupLabel];
    [self setupButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setupLabel {
    //***   From Date
    
    UILabel *fromDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(myLabelXDirection+40, myLabelYDirection, myLabelWidth, myLabelHeight)];
    fromDateLabel.text = @"From:";
    fromDateLabel.textColor = [UIColor grayColor];
    
    [self.view addSubview:fromDateLabel];
    
    self.fromDateButton = [[UIButton alloc]initWithFrame:CGRectMake(myLabelXDirection,myLabelYDirection+myLabelHeight,myLabelWidth, myLabelHeight)];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    
    [self.fromDateButton setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    
    [self.fromDateButton setTitleColor:[IXIColors seaGreenColor] forState:UIControlStateNormal];
    [self.fromDateButton.layer setBorderWidth:2.0];
    [self.fromDateButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.fromDateButton.layer setCornerRadius:5.0];
    
    self.fromDate = [NSDate date];

    [self.view addSubview:self.fromDateButton];
    
    [self.fromDateButton addTarget:self action:@selector(setupDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    
    //***    To Date
    UILabel *toDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(my2LabelXDirection+50, myLabelYDirection,myLabelWidth,myLabelHeight)];
    toDateLabel.text = @"To:";
    toDateLabel.textColor = [UIColor grayColor];
    
    [self.view addSubview:toDateLabel];
    
    self.toDateButton = [[UIButton alloc]initWithFrame:CGRectMake(my2LabelXDirection,myLabelYDirection+myLabelHeight,myLabelWidth, myLabelHeight)];
    
    [_toDateButton setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    
    [self.toDateButton setTitleColor:[IXIColors seaGreenColor] forState:UIControlStateNormal];
    [self.toDateButton.layer setBorderWidth:2.0];
    [self.toDateButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.toDateButton.layer setCornerRadius:5.0];
    self.toDate = [NSDate date];
    
    [self.view addSubview:self.toDateButton];
    
    [self.toDateButton addTarget:self action:@selector(setupDatePicker2:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupDatePicker: (id) sender {
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 300, 320, 100)];
    _datePicker.backgroundColor = [IXIColors veryLightGrayColor];
    _datePicker.date = [NSDate date];
    _datePicker.hidden = NO;
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    [_datePicker addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_datePicker];
}

-(void)changeDateInLabel : (id) sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.fromDate = _datePicker.date;
    
    [self.fromDateButton setTitle:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:_datePicker.date]] forState:UIControlStateNormal];
}

-(void)setupDatePicker2: (id) sender {
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 300, 320, 100)];
    _datePicker.backgroundColor = [IXIColors veryLightGrayColor];
    _datePicker.date = [NSDate date];
    _datePicker.hidden = NO;
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    [_datePicker addTarget:self action:@selector(changeDateInLabel2:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_datePicker];
}

-(void)changeDateInLabel2: (id) sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.toDate = _datePicker.date;
    
    [self.toDateButton setTitle:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:_datePicker.date]] forState:UIControlStateNormal];
}

-(void)setupButton {
    //Show Button
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 135, 140, 30)];
    [button setTitle:@"Show Expense" forState:UIControlStateNormal];
    [button setBackgroundColor:[IXIColors giantsOrangeColor]];
    
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(setupTableView:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupTableView:(id)sender {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, 320, 370) style:UITableViewStylePlain];
    
    [self.myTableView setDelegate:self];
    [self.myTableView setDataSource:self];
    
    NSDateComponents *components1 = [[NSDateComponents alloc] init];
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    
    components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.fromDate];
    
    components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.toDate];
                                    
    _expenseDBEdit = [[ExpenseDBEdit alloc]init];
    
    _expenseList = [_expenseDBEdit selectExpensesFromDateWithDayIndex:[components1 day] andMonth:[components1 month] andYear:[components1 year] toDateWithDayIndex:[components2 day] andMonth:[components2 month] andYear:[components2 year]];
        
    [self.view addSubview:self.myTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"no of rows called");
    return [_expenseList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cell for row called");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Expense *expense = [[Expense alloc]init];
    expense = [_expenseList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@" ,expense.title];
    
    UIFont *myFont = [UIFont fontWithName:@"Comic Sans" size:8.0 ];

    cell.textLabel.font =myFont;
    cell.textLabel.textColor = [UIColor grayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(230, 0, 100, 30)];
    label.text = [NSString stringWithFormat:@"Rs. %.0f/-", expense.amount];
    label.font = myFont;
    label.textColor = [IXIColors seaGreenColor];
    [cell.contentView addSubview:label];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self getStringFromDate:expense.dateAdded]];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:10.0];
    
    NSString *imageName = [NSString stringWithFormat:@"%@", [expense.category stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
    NSString *imageName1 = [NSString stringWithFormat:@"%@", [imageName stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
    
    UIImage *cellImage = [UIImage imageNamed:imageName1];
    
    if (cellImage == nil)
    {
        cellImage = [UIImage imageNamed:@"Other.png"];
    }
    
    cell.imageView.image = cellImage;
    CGFloat widthScale = rowWidth/cellImage.size.width;
    CGFloat heightScale = rowHeight/cellImage.size.height;
    
    cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    
    
    NSLog(@"%.2f %@ %@",expense.amount, expense.category, [self getStringFromDate:expense.dateAdded]);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Expense *myExpense = [[Expense alloc] init];
    myExpense = [self.expenseList objectAtIndex:indexPath.row];
    NSLog(@"my expense title is %@", myExpense.title);

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.expenseList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        _expenseDBEdit = [[ExpenseDBEdit alloc] init];
        [_expenseDBEdit deleteRow:myExpense];
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
        
    }
    
}


-(void)setupDefaultTableView {
    UITableView *defaultTableView;
    defaultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 180, 320, 370) style:UITableViewStylePlain];
    
    [defaultTableView setDelegate:self];
    [defaultTableView setDataSource:self];
    
    _expenseDBEdit = [[ExpenseDBEdit alloc]init];
    
    _expenseList = [_expenseDBEdit selectAllExpenses];
    
    [self.view addSubview:defaultTableView];

}

-(NSString *)getStringFromDate: (NSDate *)myDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [dateFormatter stringFromDate:myDate];
    return dateString;
}

@end
