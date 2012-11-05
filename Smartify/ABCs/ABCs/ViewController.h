//
//  ViewController.h
//  ABCs
//
//  Created by Erran Carey on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController{
}

//Alphabet Related Arrays and UILabel
@property (strong, nonatomic) NSArray *alphabetLower;
@property (strong, nonatomic) NSArray *alphabetUpper;
@property (strong, nonatomic) NSArray *alphabetComplete;
@property (strong, nonatomic) IBOutlet UILabel *alphaLabel;
@property (strong, nonatomic) IBOutlet UILabel *ABCsLabel;
/////////////////////////////////////

//Animal/Object Related Strings, Button, Image, and Sound.
@property (strong, nonatomic) NSString *animal;
@property (strong, nonatomic) NSString *animal2;
@property (strong, nonatomic) IBOutlet UIButton *animalButton;
@property (strong, nonatomic) IBOutlet UIImageView *animalImage;
@property (strong, nonatomic) AVAudioPlayer *animalSound;
@property (strong, nonatomic) IBOutlet UIImageView *apple;
//////////////////////////////////////////////////////////

//Integer for index
@property int index;
///////////////////

//Letter related content 'alphabet array' at index 'index'
@property (strong, nonatomic) NSString *letter;
@property (strong, nonatomic) IBOutlet UIButton *letterButton;
@property (strong, nonatomic) AVAudioPlayer *letterSound;
//////////////////////////////////////////////////////////

//Segmented control
@property (strong, nonatomic) IBOutlet UISegmentedControl *segCtrl;
@property (strong, nonatomic) IBOutlet UIButton *segCtrl0;
@property (strong, nonatomic) IBOutlet UIButton *segCtrl1;
@property (strong, nonatomic) IBOutlet UIButton *segCtrl2;
///////////////////

//More...
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
//////////////

//IBActions
-(IBAction)animalPressed;
-(IBAction)letterPressed;
-(IBAction)go_Stop;
-(IBAction)segCtrlSel0;
-(IBAction)segCtrlSel1;
-(IBAction)segCtrlSel2;
////////////

//Void functions
-(void)back;
-(void)forward;
-(void)go;
-(void)stop;
-(void)letterShown;
-(void)startBackwardAnimation;
-(void)startForwardAnimation;
-(void)updateLabel;
////////////////

@end