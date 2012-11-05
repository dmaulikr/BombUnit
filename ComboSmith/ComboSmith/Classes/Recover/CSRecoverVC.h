//
//  CSRecoverVC.h
//  ComboSmith
//
//  Created by Erran Carey on 3/10/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface CSRecoverVC : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate> {
    sqlite3 *comboDB;
}

//This button is used to send the action of "Recover" after receiving touch up inside.
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *initialInvoker;
@property (strong, nonatomic) IBOutlet UIButton *inputInvoker;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UISlider *customSlider;

//This picker is set to dynamically change depending on the user's selection of a 3-6 digit value for the combo.
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

//These labels are used for displaying variables as they're changed.
@property (strong, nonatomic) IBOutlet UILabel *label;

//Columns are declared properties. (Used as per selection of 3-6 digit value.)
@property (strong, nonatomic) NSArray *column1;
@property (strong, nonatomic) NSArray *column2;
@property (strong, nonatomic) NSArray *column3;
@property (strong, nonatomic) NSArray *column4;
@property (strong, nonatomic) NSArray *column5;
@property (strong, nonatomic) NSArray *column6;
@property (strong, nonatomic) NSArray *testData;

// Other variables

@property (nonatomic, assign) int numberOfColumns;
@property (nonatomic, assign) int permutationsIndex;
@property (nonatomic, assign) int permutationsCount;
@property (strong, nonatomic) NSString *userInput;
@property (strong, nonatomic) NSString *session;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *combo;
@property (strong, nonatomic) NSArray *permutations;
@property (strong, nonatomic) NSArray *currentPermutation;

// User Functions
- (IBAction) Recover;
- (IBAction) doubleTapBack;
- (IBAction) backButtonPressed;
- (IBAction) forwardButtonPressed;
- (IBAction) triggerInputAlert;
- (IBAction) sliderMoved;
- (IBAction)initiateSave;
- (IBAction)initiatePause;
- (void) saveCombo;
- (void) pauseSession;
- (void) submitData;
- (void) getAllPermutations;
- (void) getCurrentPermutation;
- (void) decrementPermutation;
- (void) incrementPermutation;
@end