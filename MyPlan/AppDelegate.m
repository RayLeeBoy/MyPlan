//
//  AppDelegate.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/10/29.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [ViewController new];
    
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
    
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    [SVProgressHUD setContainerView:self.window];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
