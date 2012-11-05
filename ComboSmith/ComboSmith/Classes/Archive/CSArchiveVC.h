//
//  CSArchiveVC.h
//  ComboSmith
//
//  Created by Erran Carey on 3/12/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface CSArchiveVC : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *comboNameArray;
    NSMutableArray *comboIDArray;
    CSArchiveVC *findCombos;
    sqlite3 *comboDB;
    IBOutlet UITableView *table;

}
// Actions
-(IBAction)initiateSave;
- (void)tableReload;
//IBOutlets:
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIButton *editComboButton;
@property (strong, nonatomic) IBOutlet UIButton *savedComboButton;
@property (strong, nonatomic) IBOutlet UIButton *savedSessionsButton;
//Columns are declared properties. (Used as per selection of 3-6 digit value.)
@property (strong, nonatomic) NSArray *column1;
@property (strong, nonatomic) NSArray *column2;
@property (strong, nonatomic) NSArray *column3;
@property (strong, nonatomic) NSArray *column4;
@property (strong, nonatomic) NSArray *column5;
@property (strong, nonatomic) NSArray *column6;
@property (strong, nonatomic) NSArray *testData;
@property (strong, nonatomic) NSMutableArray *listData;
// Variables for dynamic functionallity:
@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, strong) NSString *combo;
@property (nonatomic, strong) NSString *toBeSavedCombo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *valueOfRow;
@property (nonatomic, strong) NSString *splitMeCombo;
@property (nonatomic, strong) NSMutableArray *comboArray;



@end
