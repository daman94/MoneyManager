//
//  ExpenseDBEdit.h
//  MoneyManager
//
//  Created by Daman Saroa on 02/07/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Expense.h"

@interface ExpenseDBEdit : NSObject
{
    sqlite3 *db;
}

@property(strong,nonatomic) NSMutableArray *expenseArr;
@property(strong,nonatomic) NSString *databasePath;

-(void)prepareDatabase;
-(void)insertExpense:(Expense *)expense;

-(NSMutableArray *)selectAllExpenses;
-(NSMutableArray *)selectExpenseFrom:(NSDate *)xdate To:(NSDate *)ydate;
-(NSMutableArray *)selectExpensesOfMonthWithIndex:(NSUInteger)monthIndex andYear:(NSUInteger)yearInt;
-(NSMutableArray *)selectExpensesFromDateWithDayIndex:(NSUInteger)fromDayIndex andMonth:(NSUInteger)fromMonthIndex andYear:(NSUInteger)fromYearInt toDateWithDayIndex:(NSUInteger)toDayIndex andMonth:(NSUInteger)toMonthIndex andYear:(NSUInteger)toYearInt;
-(NSMutableArray *)selectExpensesWithDifferentCategories;
-(void)deleteRow: (Expense *)myExpense;
@end
