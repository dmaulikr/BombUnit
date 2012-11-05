//
//  CFMAdditionViewController.h
//  Classic Flashcards Math
//
//  Created by Erran Carey on 3/22/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>{
}
//Variables for FlashCards:
@property int baseNumber;
@property int i;
@property int answer;
@property int maxNumber;
@property (strong, nonatomic) NSString *operatorSymbol;

//Outlets for arithmetic:
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIImageView *cloud;
@property (strong, nonatomic) IBOutlet UILabel *iLabel;
@property (strong, nonatomic) IBOutlet UILabel *baseNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentCard;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lineLabel;
@property (strong, nonatomic) IBOutlet UIImageView *vert;
@property (strong, nonatomic) IBOutlet UILabel *operatorLabel;
@property (strong, nonatomic) IBOutlet UILabel *mathLabel;
@property (strong, nonatomic) IBOutlet UILabel *randomLabel;
@property (strong, nonatomic) IBOutlet UILabel *whichSign;
@property (strong, nonatomic) IBOutlet UILabel *pickerLabel;
@property (strong, nonatomic) IBOutlet UILabel *whichNumber;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;


//Stepper:
//@property (strong, nonatomic) IBOutlet UIStepper *stepper;

//NSMutableArray:
@property (strong, nonatomic) NSMutableArray *pickerValues;
@property (strong, nonatomic) NSMutableArray *digitsArray;

//Button:
@property (strong, nonatomic) IBOutlet UIButton *toggleButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UISwitch *isRandom;

//Segmented Control:
@property (strong, nonatomic) IBOutlet UISegmentedControl *segCtrl;

//Actions:
-(IBAction)toggleAnswer;
-(void)startAnimation;
-(void)updateCounter;
-(IBAction)forward;
-(IBAction)back;
-(void)toggledSegCtrl;
-(IBAction)go;
-(IBAction)stop;
-(void)doMath;

@end