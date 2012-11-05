//
//  CSAppDelegate.m
//  ComboSmith
//
//  Created by Erran Carey on 3/10/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import "CSAppDelegate.h"

@implementation CSAppDelegate

@synthesize window = _window;
@synthesize viewController;
@synthesize navController;
\
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor cyanColor]];
    [self.window makeKeyAndVisible];
    [window addSubview:[navController view]];
    return YES;
}
- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end