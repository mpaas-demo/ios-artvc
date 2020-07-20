//
//  AppDelegate.m
//  ARTVCDemo
//
//  Created by kuoxuan on 2020/7/17.
//  Copyright © 2020 mPaaS. All rights reserved.
//

#import "AppDelegate.h"
#import "ARTVCDemoMainVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ARTVCDemoMainVC alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
