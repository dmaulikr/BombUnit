//
//  CSGenerateVC.h
//  ComboSmith
//
//  Created by Erran Carey on 3/10/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface CSGenerateVC : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate> {
    sqlite3         *comboDB;
}

//Declares IBOutlets
//This button is used to send the action of "Generate" after receiving touch up inside.
@property (strong, nonatomic) IBOutlet UIButton *generateButton;
@property (strong, nonatomic) IBOutlet UIButton *initialGenerateButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

//This picker is set to dynamically change depending on the user's selection of a 3-6 digit value for the combo.
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

//This label is used for a dynamic view of the array being printed and will have the option of being saved.
@property (strong, nonatomic) IBOutlet UILabel *label;

//Data Junk
@property (strong, nonatomic) NSString *combo;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *session;
@property (strong, nonatomic) NSString *cperm;

//Columns are declared properties. (Used as per selection of 3-6 digit value.)
@property (strong, nonatomic) NSArray *column1;
@property (strong, nonatomic) NSArray *column2;
@property (strong, nonatomic) NSArray *column3;
@property (strong, nonatomic) NSArray *column4;
@property (strong, nonatomic) NSArray *column5;
@property (strong, nonatomic) NSArray *column6;
@property (strong, nonatomic) NSArray *testData;

// Variables for dynamic functionallity
@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) int noRepeatNumber;
@property (nonatomic, assign) int randomNumber;


// User Functions
- (IBAction)Generate;
- (void)getRandomNumber;
- (IBAction)toggleControls:(id)sender;
- (void) saveCombo;
- (IBAction)initiateSave;
@end