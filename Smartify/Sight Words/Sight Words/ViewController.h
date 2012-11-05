//
//  ViewController.h
//  ABCs
//
//  Created by Erran Carey on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
}

//Sight Word Related Arrays and UILabel
@property (strong, nonatomic) NSArray *sightWords;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) IBOutlet UILabel *sightWordLabel;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UILabel *isRandomLabel;
/////////////////////////////////////

//Integer for index
@property int index;
@property int index_old;
///////////////////

//Sight Word related content 'alphabet array' at index 'index'
@property (strong, nonatomic) NSString *sightWord;
@property (strong, nonatomic) IBOutlet UIButton *sightWordButton;
@property (strong, nonatomic) IBOutlet UISwitch *isRandom;
//@property (strong, nonatomic) AVAudioPlayer *sightWordSound;
//////////////////////////////////////////////////////////


//More...
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
//////////////

//IBActions
//-(IBAction)sightWordPressed;
////////////

//Void functions
-(void)back;
-(void)decrement;
-(void)forward;
-(void)go;
-(void)increment;
-(void)stop;
-(void)sightWordShown;
-(void)startBackwardAnimation;
-(void)startForwardAnimation;
-(void)updateLabel;
////////////////

@end