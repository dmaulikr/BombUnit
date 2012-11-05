//
//  ViewController.m
//  ABCs
//
//  Created by Erran Carey on 3/30/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


@synthesize alphabetComplete;
@synthesize alphabetLower;
@synthesize alphabetUpper;
@synthesize animal;
@synthesize animal2;
@synthesize animalButton;
@synthesize animalImage;
@synthesize ABCsLabel;
@synthesize animalSound;
@synthesize alphaLabel;
@synthesize apple;
@synthesize goButton;
@synthesize index;
@synthesize letter;
@synthesize letterButton;
@synthesize letterSound;
@synthesize logo;
@synthesize segCtrl;
@synthesize segCtrl0;
@synthesize segCtrl1;
@synthesize segCtrl2;

-(void)go{
        self.index = 0;
        [self updateLabel];
        [self letterShown];
        alphaLabel.hidden = NO;
        animalButton.hidden = NO;
        animalImage.hidden = NO;
        apple.hidden = YES;
        [goButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
        letterButton.hidden = NO;
        letterButton.hidden = NO;
        logo.hidden = YES;
        ABCsLabel.hidden = YES;
        segCtrl.hidden = YES;
        segCtrl0.hidden = YES;
        segCtrl1.hidden = YES;
        segCtrl2.hidden = YES;
}
-(void)stop{
        self.index = 0;
        [self updateLabel];
        [self letterShown];
        alphaLabel.hidden = YES;
        animalButton.hidden = YES;
        ABCsLabel.hidden = NO;
        animalImage.hidden = YES;
        apple.hidden = NO;
        [goButton setImage:[UIImage imageNamed:@"go.png"] forState:UIControlStateNormal];
        letterButton.hidden = YES;
        logo.hidden = NO;
        segCtrl.hidden = NO;
        segCtrl0.hidden = NO;
        segCtrl1.hidden = NO;
        segCtrl2.hidden = NO;
}
-(IBAction)go_Stop{
    [self updateLabel];
    if(alphaLabel.hidden == YES)
        [self go];
    else if(alphaLabel.hidden == NO)
        [self stop];
}

-(IBAction)letterPressed{
    [self.letterSound play];
}

-(IBAction)animalPressed{
    [self.animalSound play];
}

-(IBAction)segCtrlSel0{
    segCtrl.selectedSegmentIndex = 0;
    [self updateLabel];
    [self letterShown];
}

-(IBAction)segCtrlSel1{
    segCtrl.selectedSegmentIndex = 1;
    [self updateLabel];
    [self letterShown];
}

-(IBAction)segCtrlSel2{
    segCtrl.selectedSegmentIndex = 2;
    [self updateLabel];
    [self letterShown];
}

-(void)letterShown{
    //Determines which case to display for the letter.
    [self updateLabel];
    //Holds the current letter as a string.
    letter = [self.alphabetLower objectAtIndex:self.index];
    //Hold the current animal as a string with "letter.png" format
    animal = [NSString stringWithFormat:@"%@.png",[self.alphabetLower objectAtIndex:self.index]];
    //Sends an image named "letter.png" to the UIImageView animalImage
    self.animalImage.image = [UIImage imageNamed:animal];
    //Tells animal to hold a string with"letterletter" format instead now
    animal2 = [NSString stringWithFormat:@"%@%@",letter,letter];
    //defines the path for letterSound
    NSString *letterPath = [[NSBundle mainBundle] pathForResource:letter ofType:@"mp3"];
    self.letterSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:letterPath] error:NULL];
    //defines the path for animalSound
    NSString *animalPath = [[NSBundle mainBundle] pathForResource:animal2 ofType:@"mp3"];
    self.animalSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:animalPath] error:NULL];
}
-(void)startForwardAnimation{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:.60];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
}
-(void)startBackwardAnimation{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:.60];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
}

-(void)updateLabel{
    if(segCtrl.selectedSegmentIndex == 1){
        alphaLabel.text = [self.alphabetUpper objectAtIndex:self.index];
    }
    
    if(segCtrl.selectedSegmentIndex == 2){
        alphaLabel.text = [self.alphabetComplete objectAtIndex:self.index];
    }
    
    else if (segCtrl.selectedSegmentIndex == 0){
        alphaLabel.text = [self.alphabetLower objectAtIndex:self.index];
    }}
-(void)forward{
    if(index < 25 && alphaLabel.hidden == NO){
        self.index++;
        [self startForwardAnimation];
        [UIView commitAnimations];
        [self letterShown];
    }
    else if(index == 25 && alphaLabel.hidden == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smartify" message:@"This is the last flash card." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
        [alert release];
    }

}
    
-(void)back{
    if(index > 0 && alphaLabel.hidden == NO){
        self.index--;
        [self startBackwardAnimation];
        [UIView commitAnimations];
        [self letterShown];
    }
    else if(alphaLabel.hidden == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smartify" message:@"This is the first flash card." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
        [alert release];
    }
}
- (void)leftSwiped:(UIGestureRecognizer *)recognizer {
    //Throw the view switch junk hizere.
    //Forward
    [self forward];
}
- (void)rightSwiped:(UIGestureRecognizer *)recognizer {
    //Throw the view switch junk hizere.
    //back
    [self back];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smartify" message:@"Swipe left or right to move the flash cards." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
    [alert release];
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwiped:)];
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwiped:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:left];
    [self.view addGestureRecognizer:right];
    self.index = 0;
    alphaLabel.text = @"a";
    self.alphabetLower = [[NSArray alloc] initWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",
                          @"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    
    self.alphabetUpper = [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",
                          @"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
    self.alphabetComplete = [[NSArray alloc] initWithObjects:@"Aa",@"Bb",@"Cc",@"Dd",@"Ee",@"Ff",@"Gg",@"Hh",@"Ii",@"Jj",@"Kk",@"Ll",@"Mm",
                          @"Nn",@"Oo",@"Pp",@"Qq",@"Rr",@"Ss",@"Tt",@"Uu",@"Vv",@"Ww",@"Xx",@"Yy",@"Zz",nil];
    [self letterShown];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end