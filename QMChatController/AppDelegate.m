//
//  AppDelegate.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "AppDelegate.h"

#import "QMChatController.h"

static const NSUInteger kApplicationID = 28783;
static NSString * const kAuthKey = @"b5bVGCHHv6rcAmD";
static NSString * const kAuthSecret = @"ySwEpardeE7ZXHB";
static NSString * const kAccountKey = @"7yvNe17TnjNUqDoPwfqp";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [QBSettings setApplicationID:kApplicationID];
    [QBSettings setAuthKey:kAuthKey];
    [QBSettings setAuthSecret:kAuthSecret];
    [QBSettings setAccountKey:kAccountKey];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor  = [UIColor whiteColor];
    
    QMChatController *chatController = [[QMChatController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chatController];
    
    _window.rootViewController = navigationController;
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
