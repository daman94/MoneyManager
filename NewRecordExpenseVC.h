//
//  NewRecordExpenseVC.h
//  MoneyManager
//
//  Created by Daman Saroa on 25/06/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Expense.h"
#import "ExpenseDBEdit.h"

@interface NewRecordExpenseVC : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

-(id)initWithTabBar;

@end
