//
//  AppDelegate.m
//  MoneyManager
//
//  Created by Daman Saroa on 23/06/14.
//  Copyright (c) 2014 Daman Saroa. All rights reserved.
//

#import "AppDelegate.h"
#import "IXIColors.h"
#import "ExpenditureViewController.h"
#import "NewRecordExpenseVC.h"
#import "PieChartViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor whiteColor];
    
    /*
    MainPageVC *mainPage = [[MainPageVC alloc]init];
    
    UINavigationController *mainNavController = [[UINavigationController alloc]initWithRootViewController:self.myTabBarController];
    mainNavController.navigationBar.translucent = NO;
    
    [[UINavigationBar appearance]setBarTintColor:[IXIColors seaGreenColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Arial-Bold" size:0.0],
      NSFontAttributeName,
      nil]];
     
     */
    
    self.myTabBarController = [[UITabBarController alloc] init];
    NSMutableArray *myArray = [[NSMutableArray alloc] initWithCapacity:3];

    ExpenditureViewController *myRootViewController = [[ExpenditureViewController alloc] initWithTabBar];
    UINavigationController *localNavigationController = [[UINavigationController alloc] initWithRootViewController:myRootViewController];
    [myArray addObject:localNavigationController];
   
    NewRecordExpenseVC *firstViewController = [[NewRecordExpenseVC alloc] initWithTabBar];
    localNavigationController = [[UINavigationController alloc]initWithRootViewController:firstViewController];
    [myArray addObject:localNavigationController];
    
    PieChartViewController *secondViewController = [[PieChartViewController alloc] initWithTabBar];
    localNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    [myArray addObject:localNavigationController];
    
    [[UINavigationBar appearance]setBarTintColor:[IXIColors seaGreenColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Arial-Bold" size:0.0],
      NSFontAttributeName,
      nil]];
    
    self.myTabBarController.viewControllers = myArray;
        
    self.window.rootViewController = self.myTabBarController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
