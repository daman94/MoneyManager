//
//  ExpenditureViewController.h
//  MoneyManager
//
//  Created by Daman Saroa on 05/07/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"
#import "ExpenseDBEdit.h"

@interface ExpenditureViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(strong,nonatomic) UIButton *fromDateButton;
@property(strong,nonatomic) UIButton *toDateButton;
@property(strong,nonatomic) UIDatePicker *datePicker;

@property(strong,nonatomic) UITableView *myTableView;

@property(strong,nonatomic) ExpenseDBEdit *expenseDBEdit;
@property(strong,nonatomic) NSMutableArray *expenseList;

@property(strong,nonatomic) NSDate *fromDate;
@property(strong,nonatomic) NSDate *toDate;

@property(strong,nonatomic) NSArray *thumbnails;

-(id)initWithTabBar;

@end
