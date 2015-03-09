//
//  PieChartViewController.h
//  MoneyManager
//
//  Created by Daman Saroa on 10/07/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartViewController : UIViewController<CPTPlotDataSource, UIActionSheetDelegate>

-(id)initWithTabBar;

@end
