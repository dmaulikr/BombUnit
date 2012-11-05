//
//  CSDataHandler.h
//  ComboSmith
//
//  Created by Erran Carey on 3/16/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface CSDataHandler : UIViewController {
    UITextField     *name;
    UITextField     *combo;
    UITextField     *cperm;
    UITextField     *session;
    UILabel         *status;
    NSString        *databasePath;
    sqlite3         *comboDB;
}
@property (retain, nonatomic) IBOutlet UITextField *name;
@property (retain, nonatomic) IBOutlet UITextField *combo;
@property (retain, nonatomic) IBOutlet UITextField *cperm;
@property (retain, nonatomic) IBOutlet UITextField *session;
@property (retain, nonatomic) IBOutlet UILabel *status;
- (IBAction) saveData;
- (IBAction) findCombo;
@end