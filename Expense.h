//
//  Expense.h
//  MoneyManager
//
//  Created by Daman Saroa on 01/07/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject

@property(nonatomic) float amount;
@property(strong,nonatomic) NSString *category;
@property (nonatomic, strong) NSDate *dateAdded;
@property(strong,nonatomic) NSString *title;

@end
