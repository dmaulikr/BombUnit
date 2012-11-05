//
//  CSAppDelegate.h
//  ComboSmith
//
//  Created by Erran Carey on 3/10/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSArchiveVC;
@class CSHelpVC;

@interface CSAppDelegate : UIResponder <UIApplicationDelegate>{
    UIWindow *window;
    CSArchiveVC *viewController;
    CSHelpVC *navController;
}


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet CSArchiveVC *viewController;
@property (nonatomic, retain) IBOutlet CSHelpVC *navController;

@end