//
//  ExpenseDBEdit.m
//  MoneyManager
//
//  Created by Daman Saroa on 02/07/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import "ExpenseDBEdit.h"

@implementation ExpenseDBEdit

-(void)prepareDatabase {
    
    NSLog(@"prepareDatabase called!!!");
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    self.databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"MyDatabase.db"]];
    
    NSLog(@"DB Path: %@", _databasePath);
    
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &db) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt ="CREATE TABLE IF NOT EXISTS EXPENSE_TABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, AMOUNTFIELD INTEGER, CATEGORYFIELD TEXT, MY_DATE DATETIME, TITLEFIELD TEXT)";
            
            if (sqlite3_exec(db, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            else
            {
                NSLog(@"Success in creating table");
            }
            sqlite3_close(db);
        }
        else
        {
            NSLog(@"Failed to open/create database");
        }
    }
    else
    {
        NSLog(@"file exists already");
    
//        NSError *err;
//        [filemgr removeItemAtPath:_databasePath error:&err];
//        if (err) {
//            NSLog(@"error ");
//        }
//        else {
//            NSLog(@"file deleted");
//        }
        
    }
}

- (void) insertExpense: (Expense *)expense {
    NSLog(@"insert expense called");
    
    NSString *myStringDate = [self getStringFromDate:expense.dateAdded];
    
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPath[0];
    
    NSString *databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"MyDatabase.db"]];
    const char *dbpath = [databasePath UTF8String];
    
    if (!(sqlite3_open(dbpath, &db)) == SQLITE_OK)
    {
        NSLog(@"error in Insert/Save method!");
        return;
    }
    else
    {
        NSLog(@"insert statement");
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO EXPENSE_TABLE (AMOUNTFIELD, CATEGORYFIELD , MY_DATE, TITLEFIELD) VALUES ('%.2f', '%@' , '%@', '%@')", expense.amount, expense.category , myStringDate , expense.title];
        
        const char *sql = [insertSQL UTF8String];
        
        char *errMsg = nil;
        
        if (sqlite3_exec(db, sql, NULL, NULL, &errMsg) == SQLITE_OK)
        {
            NSLog(@"row added %.2f %@ %@ %@", expense.amount, expense.category, myStringDate, expense.title);
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Expense Added!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            myAlertView.alertViewStyle = UIAlertViewStyleDefault;
            [myAlertView show];
        }
        else
        {
            NSLog(@"INSERT STATEMENT ERROR");
        }
    }
}


-(NSMutableArray *)selectAllExpenses {
    NSLog(@"select all expenses called");
    NSMutableArray *expArray = [[NSMutableArray alloc]init];
    
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = dirPath[0];
    
    NSString *databasePath = [[NSString alloc]initWithString:[docDir stringByAppendingPathComponent:@"MyDatabase.db"]];
    const char *dbpath = [databasePath UTF8String];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];

    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        NSLog(@"FILE DOESTN EXIST");
    }
    else {
    
    if (sqlite3_open(dbpath, &db) != SQLITE_OK)
    {
        NSLog(@"Fialed to open db");
    }
    else
    {
        NSLog(@"success in opening db");
        
        NSString *select_sql = @"SELECT * FROM EXPENSE_TABLE";
        const char *sql_statement = [select_sql UTF8String];
        
        sqlite3_stmt *statement;
        
        if ((sqlite3_prepare_v2(db, sql_statement, -1, &statement, NULL)) != SQLITE_OK)
        {
            NSLog(@"Problem with select statement");
        }
        else
        {
            do {
                char *checkChar = (char *)sqlite3_column_text(statement, 1);
                
                if (checkChar != NULL)
                {
                    Expense *newExpense = [[Expense alloc]init];
                    
                    newExpense.amount = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)] floatValue];
                    newExpense.category = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
                    newExpense.dateAdded = [self getDateFromString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)]];
                    newExpense.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
                    
                    [expArray addObject:newExpense];
                    
                    newExpense = nil;
                    
                    NSLog(@"Expense added in array");
                }
                
            } while (sqlite3_step(statement) == SQLITE_ROW);
            
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    }
    return expArray;
}

-(NSMutableArray *)selectExpenseFrom:(NSDate *)xdate To:(NSDate *)ydate {
    
    NSMutableArray *expArray = [[NSMutableArray alloc]init];
    
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = dirPath[0];
    
    NSString *databasePath = [[NSString alloc]initWithString:[docDir stringByAppendingPathComponent:@"MyDatabase.db"]];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) != SQLITE_OK)
    {
        NSLog(@"Fialed to open db");
    }
    else
    {
        NSLog(@"success in opening db");
        
        NSString *xdateString = [self getStringFromDate:xdate];
        NSString *ydateString = [self getStringFromDate:ydate];
        
        NSString *select_sql =[ NSString stringWithFormat:@"SELECT * FROM EXPENSE_TABLE WHERE MY_DATE >= '%@' AND MY_DATE <= '%@' ", xdateString, ydateString];
        
        
        const char *sql_statement = [select_sql UTF8String];
        
        sqlite3_stmt *statement;
        
        if ((sqlite3_prepare_v2(db, sql_statement, -1, &statement, NULL)) != SQLITE_OK)
        {
            NSLog(@"Problem with select statement");
        }
        else
        {
            do {
                NSLog(@"STEP STATEMENT");
                char *checkChar = (char *)sqlite3_column_text(statement, 1);
                
                if (checkChar != NULL)
                {
                    NSLog(@"INSIDE CHECKCHAR NOT NULL");
                    Expense *newExpense = [[Expense alloc]init];
                    
                    newExpense.amount = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)] floatValue];
                    newExpense.category = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
                    newExpense.dateAdded = [self getDateFromString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)]];
                    newExpense.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
                    
                    [expArray addObject:newExpense];
                    
                    newExpense = nil;
                    
                    NSLog(@"Expense added in array");
                }
            }
                while (sqlite3_step(statement) == SQLITE_ROW);
            
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return expArray;
}

-(NSMutableArray *)selectExpensesOfMonthWithIndex:(NSUInteger)monthIndex andYear:(NSUInteger)yearInt {
    
    // CHECK month Validity
    if (monthIndex <1 || monthIndex >12) {
        return [[NSMutableArray alloc] init]; // invalid search month Value should be between 1 to 12;
    }
    
    NSMutableArray *expArray = [[NSMutableArray alloc]init];
    
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = dirPath[0];
    
    NSString *databasePath = [[NSString alloc]initWithString:[docDir stringByAppendingPathComponent:@"MyDatabase.db"]];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) != SQLITE_OK)
    {
        NSLog(@"Fialed to open db");
    }
    else
    {
        NSLog(@"success in opening db");
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        
        [components setDay:1];
        [components setMonth:monthIndex];
        [components setYear:yearInt];
        
        NSDate *fromDate = [calendar dateFromComponents:components];
        
        // last day of month
        [components setDay:0];
        [components setMonth:monthIndex+1];
        
        NSDate *toDateMonth = [calendar dateFromComponents:components];
        
        NSString *select_sql =[ NSString stringWithFormat:@"SELECT * FROM EXPENSE_TABLE WHERE MY_DATE BETWEEN '%@' AND '%@' ", [self getStringFromDate:fromDate], [self getStringFromDate:toDateMonth] ];
        
        
        const char *sql_statement = [select_sql UTF8String];
        
        sqlite3_stmt *statement;
        
        if ((sqlite3_prepare_v2(db, sql_statement, -1, &statement, NULL)) != SQLITE_OK)
        {
            NSLog(@"Problem with select statement");
        }
        else
        {
            int stepResult = sqlite3_step(statement);
            NSLog(@"sqlite 3 : %d", stepResult);
            
            if (stepResult == SQLITE_ROW) {
                do {
                    NSLog(@"STEP STATEMENT");
                    char *checkChar = (char *)sqlite3_column_text(statement, 1);
                    
                    if (checkChar != NULL)
                    {
                        NSLog(@"INSIDE CHECKCHAR NOT NULL");
                        Expense *newExpense = [[Expense alloc]init];
                        
                        newExpense.amount = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)] floatValue];
                        newExpense.category = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
                        newExpense.dateAdded = [self getDateFromString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)]];
                        newExpense.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
                        
                        [expArray addObject:newExpense];
                        
                        newExpense = nil;
                        
                        NSLog(@"Expense added in array");
                    }
                } while (sqlite3_step(statement) == SQLITE_ROW);
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return expArray;
}

-(NSMutableArray *)selectExpensesFromDateWithDayIndex:(NSUInteger)fromDayIndex andMonth:(NSUInteger)fromMonthIndex andYear:(NSUInteger)fromYearInt toDateWithDayIndex:(NSUInteger)toDayIndex andMonth:(NSUInteger)toMonthIndex andYear:(NSUInteger)toYearInt {
    
    NSMutableArray *expArray = [[NSMutableArray alloc] init];
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = dirPath[0];
    
    NSString *databasePath = [[NSString alloc]initWithString:[docDir stringByAppendingPathComponent:@"MyDatabase.db"]];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) != SQLITE_OK)
    {
        NSLog(@"Fialed to open db");
    }
    else
    {
        NSLog(@"success in opening db");
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        
        // from date
        [components setDay:fromDayIndex];
        [components setMonth:fromMonthIndex];
        [components setYear:fromYearInt];
        
        NSDate *fromDate = [calendar dateFromComponents:components];
        
        // to date
        [components setDay:toDayIndex];
        [components setMonth:toMonthIndex];
        [components setYear:toYearInt];
        
        NSDate *toDate = [calendar dateFromComponents:components];
        
        NSString *select_sql =[ NSString stringWithFormat:@"SELECT * FROM EXPENSE_TABLE WHERE [MY_DATE] >= '%@' AND [MY_DATE] <= '%@' ", [self getStringFromDate:fromDate], [self getStringFromDate:toDate] ];
        
        const char *sql_statement = [select_sql UTF8String];
        
        sqlite3_stmt *statement;
        
        if ((sqlite3_prepare_v2(db, sql_statement, -1, &statement, NULL)) != SQLITE_OK)
        {
            NSLog(@"Problem with select statement");
        }
        else
        {
            int stepResult = sqlite3_step(statement);
            NSLog(@"sqlite 3 : %d", stepResult);
            
            if (stepResult == SQLITE_ROW) {
                do {
                    NSLog(@"STEP STATEMENT");
                    char *checkChar = (char *)sqlite3_column_text(statement, 1);
                    
                    if (checkChar != NULL)
                    {
                        NSLog(@"INSIDE CHECKCHAR NOT NULL");
                        Expense *newExpense = [[Expense alloc]init];
                        
                        newExpense.amount = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)] floatValue];
                        newExpense.category = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
                        newExpense.dateAdded = [self getDateFromString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 3)]];
                        newExpense.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
                        
                        [expArray addObject:newExpense];
                        
                        
                        NSLog(@"Expense added in array %.2f %@ %@", newExpense.amount, newExpense.category, newExpense.dateAdded);
                        newExpense = nil;

                    }
                } while (sqlite3_step(statement) == SQLITE_ROW);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return expArray;
}

-(NSMutableArray *)selectExpensesWithDifferentCategories {
    NSLog(@"PIE CHART METHOD CALLED");
    NSMutableArray *expArray = [[NSMutableArray alloc]init];
    
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = dirPath[0];
    
    NSString *databasePath = [[NSString alloc]initWithString:[docDir stringByAppendingPathComponent:@"MyDatabase.db"]];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) != SQLITE_OK)
    {
        NSLog(@"Fialed to open db");
    }
    else
    {
        NSLog(@"success in opening db");
        
        NSString *select_sql =[ NSString stringWithFormat:@"SELECT SUM(AMOUNTFIELD ), CATEGORYFIELD , MY_DATE , TITLEFIELD FROM EXPENSE_TABLE GROUP BY CATEGORYFIELD "];
        
        const char *sql_statement = [select_sql UTF8String];
        
        sqlite3_stmt *statement;
        
        if ((sqlite3_prepare_v2(db, sql_statement, -1, &statement, NULL)) != SQLITE_OK)
        {
            NSLog(@"Problem with select statement");
        }
        else
        {
            do {
                NSLog(@"STEP STATEMENT");
                char *checkChar = (char *)sqlite3_column_text(statement, 1);
                
                if (checkChar != NULL)
                {
                    NSLog(@"INSIDE CHECKCHAR NOT NULL");
                    Expense *newExpense = [[Expense alloc]init];
                    
                    newExpense.amount = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 0)] floatValue];
                    newExpense.category = [NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
                    
                    [expArray addObject:newExpense];
                    
                    NSLog(@"Expense added in PIE CHART with category %@ and total amount: %f",newExpense.category, newExpense.amount);

                    newExpense = nil;
                 }
            }
            while (sqlite3_step(statement) == SQLITE_ROW);
            
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return expArray;
}

//-(NSMutableArray *)deleteRow {
//    NSDictionary *d =(NSDictionary *) [YourMutableArray objectAtIndex:0];
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDir = [path objectAtIndex:0];
//    NSString *dbPath =[documentsDir stringByAppendingPathComponent:@"db.sqlite"];
//    sqlite3_open([dbPath UTF8String], &database);
//    
//    if(deleteStmt == nil)
//    {
//        
//        NSString *deleteStatementNS = [NSString stringWithFormat:
//                                       @"delete from tbl_postoffice where type = '%@'",
//                                       urusniqIDentifire];
//        const char *sql = [deleteStatementNS UTF8String];
//        
//        //const char *sql ="delete from tbl_todo where type = yourDbfildeRecored";
//        if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
//            NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
//    }
//    
//    //When binding parameters, index starts from 1 and not zero.
//    sqlite3_bind_text(deleteStmt, 1, [[d valueForKey:@"type"] UTF8String], -1, SQLITE_TRANSIENT);
//    if (SQLITE_DONE != sqlite3_step(deleteStmt))
//        NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
//    
//    sqlite3_reset(deleteStmt);
//}

-(void)deleteRow: (Expense *)myExpense {
    NSLog(@"delete a row mathod called");
    
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = dirPath[0];
    
    NSString *databasePath = [[NSString alloc]initWithString:[docDir stringByAppendingPathComponent:@"MyDatabase.db"]];
    const char *dbpath = [databasePath UTF8String];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        NSLog(@"FILE DOESTN EXIST");
    }
    else {
        
        if (sqlite3_open(dbpath, &db) != SQLITE_OK)
        {
            NSLog(@"Fialed to open db");
        }
        else
        {
            NSLog(@"success in opening db");
            
            NSString *delete_sql = [ NSString stringWithFormat:@"DELETE FROM EXPENSE_TABLE WHERE TITLEFIELD = '%@' ", myExpense.title ];
            
            const char *sql_statement = [delete_sql UTF8String];
            
            sqlite3_stmt *statement;
            
            if ((sqlite3_prepare_v2(db, sql_statement, -1, &statement, NULL)) != SQLITE_OK)
            {
                NSLog(@"Problem with delete statement");
            }
            else
            {
                sqlite3_bind_text(statement, 1, sql_statement, -1, SQLITE_TRANSIENT);
                if (SQLITE_DONE != sqlite3_step(statement))
                {
                    NSAssert1(0, @"ERROR WHILE DELETING. '%s'", sqlite3_errmsg(db));
                }
                else
                {
                    sqlite3_reset(statement);
                }
                
                sqlite3_close(db);
            NSLog(@"delete query implemented");
            }
        }
    }
}


-(NSDate *)getDateFromString: (NSString *)stringDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:stringDate];
    
    NSLog(@"string date is %@",stringDate);
    return dateFromString;
}

-(NSString *)getStringFromDate: (NSDate *)myDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormatter stringFromDate:myDate];
    NSLog(@"DATE STRING IS %@", dateString);
    return dateString;
}

@end

