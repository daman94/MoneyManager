//
//  NewRecordExpenseVC.m
//  MoneyManager
//
//  Created by Daman Saroa on 25/06/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import "NewRecordExpenseVC.h"
#import "IXIColors.h"

//Numerics
CGFloat const kLabelXDirection = 40.0;
CGFloat const kLabelYDirection = 160.0;
CGFloat const kLabelWidth = 91.0;
CGFloat const kLabelHeight = 35.0;
CGFloat const kLabelDIff = 20.0;
CGFloat const kTextFieldXDirection = 131.0;
CGFloat const kTextFieldYDirection = 160.0;
CGFloat const kTextFieldWidth = 150.0;
CGFloat const kTextFieldHeight = 35.0;
CGFloat const kTextFieldDiff = 20.0;


@interface NewRecordExpenseVC ()

@property(strong,nonatomic) UITextField *amountField;
@property(strong,nonatomic) UITextField *categoryField;
@property(strong,nonatomic) UITextField *titleField;
@property (strong,nonatomic) UIButton *date;

@property(strong,nonatomic) UIDatePicker *datePicker;

@property(strong,nonatomic) ExpenseDBEdit *expenseDBItem;


@property(nonatomic) NSMutableArray *pickerData;
@property(nonatomic) UIPickerView *myPickerView;
@property(nonatomic) UIToolbar *toolBar;
@property(nonatomic) UIToolbar *toolBar2;

@property(strong,nonatomic) NSDate *myDate;

@end

@implementation NewRecordExpenseVC

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
        self.title = @"Add Expense";
        self.tabBarItem.image = [UIImage imageNamed:@"addNewExpenses.png"];
        self.navigationItem.title = @"Add Expense";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupFirstLabel];
    [self setupSecondLabel];
    [self setupButtons];
    
    [_amountField setDelegate:self];
    [_titleField setDelegate:self];
    [_categoryField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupFirstLabel {
    //Date Button
    self.date = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 63.0f, 500.0f, 60.0f)];
    self.date.backgroundColor = [IXIColors veryLightGrayColor];
    [self.date.layer setShadowColor:(__bridge CGColorRef)([UIColor blackColor])];
    [self.date.layer setShadowOpacity:12];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    
    [_date setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    [_date setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.view addSubview:_date];
    
    [_date addTarget:self
              action:@selector(setupDatePicker)
                forControlEvents:UIControlEventTouchUpInside];
    self.myDate = [NSDate date];
}

-(void)setupSecondLabel {
    //Title Label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLabelXDirection, kLabelYDirection, kLabelWidth, kLabelHeight)];
    titleLabel.text = @" Title ";
    titleLabel.font = [UIFont fontWithName:@"Comics Sans" size:12];
    titleLabel.backgroundColor = [IXIColors seaGreenColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:titleLabel];

    //Amount Label
    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLabelXDirection, kLabelYDirection + kLabelHeight + kLabelDIff, kLabelWidth, kLabelHeight)];
    amountLabel.text = @" Amount ";
    amountLabel.font = [UIFont fontWithName:@"Comics Sans" size:12];
    amountLabel.backgroundColor = [IXIColors seaGreenColor];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:amountLabel];
    
    //Category Label
    UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLabelXDirection, kLabelYDirection + 2*(kLabelHeight + kLabelDIff), kLabelWidth, kLabelHeight)];
    categoryLabel.text = @" Category ";
    categoryLabel.font = [UIFont fontWithName:@"Comics Sans" size:12];
    categoryLabel.backgroundColor = [IXIColors seaGreenColor];
    categoryLabel.textColor = [UIColor whiteColor];
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:categoryLabel];
    
    //Title Field
    self.titleField.placeholder = @"Enter title";
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.frame = CGRectMake(kTextFieldXDirection, kTextFieldYDirection, kTextFieldWidth, kTextFieldHeight);
    self.titleField.layer.borderColor = [[UIColor blackColor]CGColor];
    self.titleField.layer.borderWidth = 1.0;
    self.titleField.textColor = [IXIColors seaGreenColor];
    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleField.layer.borderColor = [[IXIColors seaGreenColor]CGColor];
    
    [self.view addSubview:self.titleField];
    
    //Amount Field
    self.amountField.placeholder = @"Enter amount";
    self.amountField.textAlignment = NSTextAlignmentCenter;
    self.amountField.frame = CGRectMake(kTextFieldXDirection, kTextFieldYDirection + kTextFieldHeight + kTextFieldDiff, kTextFieldWidth, kTextFieldHeight);
    self.amountField.layer.borderColor = [[UIColor blackColor]CGColor];
    self.amountField.layer.borderWidth = 1.0;
    self.amountField.textColor = [IXIColors seaGreenColor];
    self.amountField.borderStyle = UITextBorderStyleRoundedRect;
    self.amountField.layer.borderColor = [[IXIColors seaGreenColor]CGColor];
    self.amountField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:self.amountField];

    //Category Field
    self.categoryField = [[UITextField alloc]initWithFrame:CGRectMake(kTextFieldXDirection, kTextFieldYDirection + 2*(kTextFieldHeight + kTextFieldDiff), kTextFieldWidth, kTextFieldHeight)];
    self.categoryField.placeholder = @"Set Category";
    self.categoryField.borderStyle = UITextBorderStyleLine;
    self.categoryField.textAlignment=NSTextAlignmentCenter;
    self.categoryField.layer.borderColor = [[UIColor blackColor]CGColor];
    self.categoryField.layer.borderWidth = 1.0;
    self.categoryField.textColor = [IXIColors seaGreenColor];
    self.categoryField.borderStyle = UITextBorderStyleRoundedRect;
    self.categoryField.layer.borderColor = [[IXIColors seaGreenColor]CGColor];
    
    [self.view addSubview:self.categoryField];
    
    [self addPickerView];
}

-(void)addPickerView {
    NSLog(@"addPICKER VIEW CALLED");

    _myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 170, 300, 250)];
    _myPickerView.backgroundColor = [UIColor whiteColor];
    _myPickerView.dataSource=self;
    _myPickerView.delegate=self;
    _myPickerView.showsSelectionIndicator = YES;
    [_myPickerView reloadAllComponents];
    
    //bar button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)];
    
    UIBarButtonItem *addCategoryButton = [[UIBarButtonItem alloc]initWithTitle:@"Add Category" style:UIBarButtonItemStyleDone target:self action:@selector(addCategoryButtonAction)];
    
    doneButton.tintColor = [UIColor whiteColor];
    addCategoryButton.tintColor = [UIColor whiteColor];
    
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(30, 300, 300, 40)];
    [_toolBar setBarStyle:UIBarStyleBlackTranslucent];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:doneButton,addCategoryButton ,nil];
    [_toolBar setItems:toolbarItems];
    [_toolBar setHidden:NO];

    _categoryField.inputView = _myPickerView;
    _categoryField.inputAccessoryView = _toolBar;
    //[_categoryField setText:[_pickerData objectAtIndex:0]];
}

//Columns in picker view
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//rows in picker view
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerData count];
}

//data in pickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.pickerData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
        [_categoryField setText:[self.pickerData objectAtIndex:row]];
}

-(void)doneButtonAction {
    [_toolBar setHidden:NO];
    [_categoryField resignFirstResponder];
}

-(void)addCategoryButtonAction {
    _categoryField.text = @"";
    [_categoryField resignFirstResponder];

    //bar button
    UIBarButtonItem *saveCategoryButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveCategoryButtonAction)];
    UIBarButtonItem *cancelAddCategoryButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAddCategoryButtonAction)];
    
    saveCategoryButton.tintColor = [UIColor whiteColor];
    cancelAddCategoryButton.tintColor = [UIColor whiteColor];
    
    _toolBar2 = [[UIToolbar alloc]initWithFrame:CGRectMake(30, 200, 300, 40)];
    [_toolBar2 setBarStyle:UIBarStyleBlackTranslucent];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:saveCategoryButton ,cancelAddCategoryButton ,nil];
    [_toolBar2 setItems:toolbarItems];
    [_toolBar2 setHidden:NO];
    
    _categoryField.inputView = UIKeyboardTypeDefault;
    _categoryField.inputAccessoryView = _toolBar2;
    
    [_categoryField becomeFirstResponder];
}

-(void)saveCategoryButtonAction {
    [_categoryField resignFirstResponder];
     NSLog(@"CATEGORY TO BE ADDED IS %@", _categoryField.text);
     [self.pickerData addObject:_categoryField.text];
    
    //save data
    NSString *myCategory = [_categoryField text];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:myCategory forKey:@"myCategory"];
    
    [defaults synchronize];
    NSLog(@"Data saved!");
    
    _categoryField.inputView =_myPickerView;
    _categoryField.inputAccessoryView = _toolBar;
}

-(void)cancelAddCategoryButtonAction {
    _categoryField.text = @"";
    [_categoryField resignFirstResponder];
    _categoryField.inputView = _myPickerView;
    _categoryField.inputAccessoryView = _toolBar;
}

-(void)setupButtons {
    //save button
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 330, 80, 35)];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[IXIColors giantsOrangeColor]];
    
    [saveButton addTarget:self action:@selector(saveData:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveButton];
    
    //cancel button
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(190, 330, 80, 35)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[IXIColors giantsOrangeColor]];
    
    [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelButton];
}

-(void) setupDatePicker {
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 340, 325, 250) ];
    
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.date = [NSDate date];
    _datePicker.hidden = NO;
    [_datePicker addTarget:self action:@selector(changeDateInLabel) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];
    
    //bar button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneDateButton)];
    
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 323, 300, 40)];
    [_toolBar setBarStyle:UIBarStyleBlackTranslucent];
    
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:doneButton, nil];
    [_toolBar setItems:toolbarItems];
    
    [self.view addSubview:_toolBar];
}

-(void)doneDateButton {
    _datePicker.hidden  = YES;
    [_toolBar setHidden:YES];
}

-(void)changeDateInLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.myDate = _datePicker.date;
    
    NSLog(@"the date entered is %@", self.myDate);
    
    [_date setTitle:[NSString stringWithFormat:@"%@", [formatter stringFromDate:_datePicker.date]] forState:UIControlStateNormal];
    
}

-(void)saveData:(id)sender {
    Expense *expenseItem = [[Expense alloc] init];
    
    expenseItem.amount = [_amountField.text floatValue];
    expenseItem.category = _categoryField.text;
    expenseItem.dateAdded = self.myDate;
    expenseItem.title = _titleField.text;
    
    
    NSLog(@"ITEM TO BE INSERTED: %@", expenseItem.title);
    
    self.expenseDBItem = [[ExpenseDBEdit alloc]init];
    
    [_expenseDBItem insertExpense:expenseItem];
    
    self.amountField.text = @"";
    self.categoryField.text = @"";
    self.titleField.text = @"";

    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
}

-(void)cancelButtonPressed {
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    self.amountField.text = @"";
    self.categoryField.text = @"";
    self.titleField.text = @"";
}

- (UITextField *) amountField {
    if (!_amountField)
    {
        _amountField = [[UITextField alloc] init];
    }
    return _amountField;
}

-(UITextField *) titleField {
    if (!_titleField)
    {
        _titleField = [[UITextField alloc] init];
    }
    return _titleField;
}

-(NSMutableArray *) pickerData {
    if (!_pickerData)
    {
        _pickerData = [[NSMutableArray alloc] initWithObjects:@"Food/Groceries",@"Gas/Petrol",@"Entertainment",@"Eat Out",@"Clothing",@"Health Care",@"Household",@"Transportation",@"Gift",@"Home/Work",@"Other", nil];
        
       // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //NSString *myCategory = [defaults objectForKey:@"myCategory"];

       // [_pickerData addObject:myCategory];
    }
    return _pickerData;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

-(NSDate *)getDateFromString: (NSString *)stringDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:stringDate];
    
    
    NSLog(@"stringdate is : %@ and datefromstring is %@",stringDate ,dateFromString);
    return dateFromString;
}

@end
