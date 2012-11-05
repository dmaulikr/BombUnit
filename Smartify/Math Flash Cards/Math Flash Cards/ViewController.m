//
//  ViewController.m
//  Classic Flashcards Math
//
//  Created by Erran Carey on 3/22/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

//Vars:
@synthesize baseNumber;
@synthesize i;
@synthesize answer;
@synthesize operatorSymbol;
@synthesize maxNumber;
//Labels:
@synthesize iLabel;
@synthesize pickerLabel;
@synthesize logo;
@synthesize mathLabel;
@synthesize cloud;
@synthesize currentCard;
@synthesize baseNumberLabel;
@synthesize whichSign;
@synthesize vert;
@synthesize whichNumber;
@synthesize lineLabel;
@synthesize answerLabel;
@synthesize randomLabel;
@synthesize operatorLabel;
//Segmented Control:
@synthesize segCtrl;
//Picker:
@synthesize picker;
//Arrays:
@synthesize pickerValues;
@synthesize digitsArray;
//Button:
@synthesize toggleButton;
@synthesize startButton;
@synthesize stopButton;
@synthesize forwardButton;
@synthesize backButton;
//Switch:
@synthesize isRandom;

#pragma mark#############################
/////////////////////////////////////////
-(void)toggledSegCtrl{
    if(segCtrl.selectedSegmentIndex == 0){
        operatorLabel.text = @"+";
    }
    else if(segCtrl.selectedSegmentIndex == 1){
        operatorLabel.text = @"–";
    }
    else if(segCtrl.selectedSegmentIndex == 2){
        operatorLabel.text = @"×";
    }
    else if(segCtrl.selectedSegmentIndex == 3){
        operatorLabel.text = @"÷";
    }
}
/////////////////////////////////////////
#pragma mark#############################



#pragma mark#############################
/////////////////////////////////////////
-(IBAction)toggleAnswer{
    if (answerLabel.hidden == YES) {
        toggleButton.hidden = YES;
        answerLabel.hidden = NO;
    }
    else if (answerLabel.hidden == NO) {
        toggleButton.hidden = NO;
        answerLabel.hidden = YES;
    }
}
/////////////////////////////////////////
#pragma mark#############################



#pragma mark#############################
/////////////////////////////////////////
-(IBAction)back{
    if(i == 1){
        backButton.hidden = YES;
    }
    else {
        backButton.hidden = NO;
    }
    if (i > 0 && iLabel.hidden == NO) {
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:.60];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [UIView commitAnimations];
        i--;
        iLabel.text = [NSString stringWithFormat:@"%i",[[digitsArray objectAtIndex:i] intValue]];
        currentCard.text = [NSString stringWithFormat:@"%i of %i",i+1,[digitsArray count]];
        forwardButton.hidden = NO;
        [self doMath];    
        toggleButton.hidden = NO;
        answerLabel.hidden = YES;
    }
}
/////////////////////////////////////////
#pragma mark#############################


-(void)fetchArray{
    NSMutableArray *digits = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
    
    while ([[digits objectAtIndex:[digits count]-1] intValue]!= maxNumber) {
        [digits removeObjectAtIndex:[digits count]-1];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[digits count]];
    
    if(isRandom.isOn == YES){
        while ([digits count] > 0) {
            NSUInteger index = arc4random() % [digits count];
            [array addObject:[digits objectAtIndex:index]];
            [digits removeObjectAtIndex:index];
        }
        self.digitsArray = array;
    }
    else{
        self.digitsArray = digits;
    }
}

#pragma mark#############################
/////////////////////////////////////////

-(void)startAnimation{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:.60];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
}
-(void)updateCounter{
    iLabel.text = [NSString stringWithFormat:@"%i",[[digitsArray objectAtIndex:i] intValue]];
    currentCard.text = [NSString stringWithFormat:@"%i of %i",i+1,[digitsArray count]];
}
-(IBAction)forward{
    backButton.hidden = NO;
    if([digitsArray objectAtIndex:i+1] == [digitsArray lastObject]){
        forwardButton.hidden = YES;
    }
    if (segCtrl.selectedSegmentIndex == 2) {
        if (i < 12 && iLabel.hidden == NO && baseNumber <= 12) {
            [self startAnimation];
            i++;
            [self updateCounter];
            [self doMath];
            toggleButton.hidden = NO;
            answerLabel.hidden = YES;
        }
    }
    else if (segCtrl.selectedSegmentIndex == 1) {
        if (i < 12 && iLabel.hidden == NO && [digitsArray lastObject] != [digitsArray objectAtIndex:i]) {
            [self startAnimation];
            i++;
            [self updateCounter];
            [self doMath];
            toggleButton.hidden = NO;
            answerLabel.hidden = YES;
        }
    }
    else if (segCtrl.selectedSegmentIndex == 3) {
        if (i < 12 && iLabel.hidden == NO && answer > -1) {
            [self startAnimation];
            i++;
            [self updateCounter];
            [self doMath];
            toggleButton.hidden = NO;
            answerLabel.hidden = YES;
        }
    }
    else {
        if (i < 12 && iLabel.hidden == NO) {
            [self startAnimation];
            i++;
            [self updateCounter];
            [self doMath];            
            toggleButton.hidden = NO;
            answerLabel.hidden = YES;
        }
    }
}
/////////////////////////////////////////
#pragma mark#############################



#pragma mark#############################
/////////////////////////////////////////
-(void)doMath{
    
    if (segCtrl.selectedSegmentIndex == 0) {
        baseNumberLabel.text = [NSString stringWithFormat:@"%i",baseNumber];
        answer = baseNumber + [[digitsArray objectAtIndex:i] intValue];
        answerLabel.text = [NSString stringWithFormat:@"%i",answer];
    }
    else if (segCtrl.selectedSegmentIndex == 1) {
        baseNumberLabel.text = [NSString stringWithFormat:@"%i",baseNumber];
        answer = baseNumber - [[digitsArray objectAtIndex:i] intValue];
        answerLabel.text = [NSString stringWithFormat:@"%i",answer];
    }
    else if (segCtrl.selectedSegmentIndex == 2) {
        baseNumberLabel.text = [NSString stringWithFormat:@"%i",baseNumber];
        answer = baseNumber * [[digitsArray objectAtIndex:i] intValue];
        answerLabel.text = [NSString stringWithFormat:@"%i",answer];
    }
    else if (segCtrl.selectedSegmentIndex == 3) {
        answer = [[digitsArray objectAtIndex:i] intValue];
        int baseTimesi = baseNumber * [[digitsArray objectAtIndex:i] intValue];
        answerLabel.text = [NSString stringWithFormat:@"%i",[[digitsArray objectAtIndex:i] intValue]];
        iLabel.text = [NSString stringWithFormat:@"%i",baseNumber];
        baseNumberLabel.text = [NSString stringWithFormat:@"%i",baseTimesi];
    }
    else{
        baseNumberLabel.text = [NSString stringWithFormat:@"%i",baseNumber];
        answer = baseNumber + [[digitsArray objectAtIndex:i] intValue];
        answerLabel.text = [NSString stringWithFormat:@"%i",answer];
    }
}
/////////////////////////////////////////
#pragma mark#############################



#pragma mark#############################
/////////////////////////////////////////
-(IBAction)go{
    // Setting maximum number
    if (segCtrl.selectedSegmentIndex == 1)
        self.maxNumber = baseNumber;
    else {
        self.maxNumber = 12;
    }
    [self fetchArray];
    currentCard.text = [NSString stringWithFormat:@"%i of %i",i+1,[digitsArray count]];
    iLabel.text = [NSString stringWithFormat:@"%i",[[digitsArray objectAtIndex:i] intValue]];
    [self toggledSegCtrl];
    if (baseNumber < 1 && segCtrl.selectedSegmentIndex == 3) {
        NSString *title = [NSString stringWithFormat:@"Oops!"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"You can't divide by zero. Add, subtract, or multiply by zero or choose a new number for division." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
        [alert release];
        
    }
    else {
        [self doMath];
        picker.hidden = YES;
        vert.hidden = YES;
        segCtrl.hidden = YES;
        whichSign.hidden = YES;
        whichNumber.hidden = YES;
        randomLabel.hidden = YES;
        isRandom.hidden = YES;
        startButton.hidden = YES;
        logo.hidden = YES;
        mathLabel.hidden = YES;
        cloud.hidden = YES;
        backButton.hidden = YES;
        currentCard.hidden = NO;
        iLabel.hidden = NO;
        forwardButton.hidden = NO;
        stopButton.hidden = NO;
        baseNumberLabel.hidden = NO;
        operatorLabel.hidden = NO;
        lineLabel.hidden = NO;
        toggleButton.hidden = NO;
    }
    if (segCtrl.selectedSegmentIndex == 1 && baseNumber == 0) {
        forwardButton.hidden = YES;
    }
}
/////////////////////////////////////////
#pragma mark#############################



#pragma mark#############################
/////////////////////////////////////////
-(IBAction)stop{
    self.tabBarController.tabBar.hidden = NO;
    i = 0;
    iLabel.text = [NSString stringWithFormat:@"%i",[[digitsArray objectAtIndex:i] intValue]];
    currentCard.text = [NSString stringWithFormat:@"%i of %i",i+1,[digitsArray count]];
    [self doMath];
    [self toggledSegCtrl];
    picker.hidden = NO;
    vert.hidden = NO;
    segCtrl.hidden = NO;
    logo.hidden = NO;
    mathLabel.hidden = NO;
    cloud.hidden = NO;
    startButton.hidden = NO;
    iLabel.hidden = YES;
    answerLabel.hidden = YES;
    randomLabel.hidden = NO;
    isRandom.hidden = NO;
    currentCard.hidden = YES;
    whichSign.hidden = NO;
    whichNumber.hidden = NO;
    stopButton.hidden = YES;
    backButton.hidden = YES;
    forwardButton.hidden = YES;
    baseNumberLabel.hidden = YES;
    operatorLabel.hidden = YES;
    lineLabel.hidden = YES;
    toggleButton.hidden = YES;
}
/////////////////////////////////////////
#pragma mark#############################



#pragma mark ######################################################################################################################
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Adding gesture recognizer. 

- (void)leftSwiped:(UIGestureRecognizer *)recognizer {
    //Throw the view switch junk hizere.
    //Forward
    if (startButton.hidden == YES && forwardButton.hidden == NO && [digitsArray lastObject] != [digitsArray objectAtIndex:i]){
        [self forward];
    }
}
- (void)rightSwiped:(UIGestureRecognizer *)recognizer {
    //Throw the view switch junk hizere.
    //back
    if (startButton.hidden == YES && backButton.hidden == NO && i > -1){
        [self back];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ######################################################################################################################



#pragma mark ######################################################################################################################
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    segCtrl.selectedSegmentIndex = 0;
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwiped:)];
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwiped:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:left];
    [self.view addGestureRecognizer:right];
    i = 0;
    stopButton.hidden = YES;
    operatorLabel.hidden = YES;
    iLabel.hidden = YES;
    toggleButton.hidden =YES;
    currentCard.hidden =YES;
    answerLabel.hidden = YES;
    baseNumberLabel.hidden = YES;
    lineLabel.hidden = YES;
    //Making the picker horiontal...
    //self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(120.0, 65.0, 80.0, 120.0)];
    CGRect frame = picker.frame;
    self.picker = [[UIPickerView alloc] initWithFrame:frame];
    frame.size.width = 60;
    frame.size.height = 216;
    frame.origin.x= 130;
    frame.origin.y = 95;
    picker.frame = frame;
    self.picker = [[UIPickerView alloc] initWithFrame:frame];
    //picker.transform = CGAffineTransformMakeRotation(3.14159/2);
    picker.transform = CGAffineTransformMakeRotation(4.71238898);
    [self.view addSubview:self.picker];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.showsSelectionIndicator = NO;
    self.picker.userInteractionEnabled = YES;
    pickerValues = [[NSMutableArray alloc] init];
    [pickerValues addObject:@"0"];
    [pickerValues addObject:@"1"];
    [pickerValues addObject:@"2"];
    [pickerValues addObject:@"3"];
    [pickerValues addObject:@"4"];
    [pickerValues addObject:@"5"];
    [pickerValues addObject:@"6"];
    [pickerValues addObject:@"7"];
    [pickerValues addObject:@"8"];
    [pickerValues addObject:@"9"];
    [pickerValues addObject:@"10"];
    [pickerValues addObject:@"11"];
    [pickerValues addObject:@"12"];
    self.vert = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selection_indicator_custom_vert.png"]];
    CGRect frame2 = vert.frame;
    frame2.size.width = 50;
    frame2.size.height = 38;
    frame2.origin.x= 134;
    frame2.origin.y = 184;
    self.vert.frame = frame2;
    [self.view addSubview:vert];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
#pragma mark ######################################################################################################################
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerValues count];
}
#pragma mark ######################################################################################################################
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerValues objectAtIndex:row];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    pickerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 60)] autorelease];
    pickerLabel.transform = CGAffineTransformMakeRotation(1.57079633);
    pickerLabel.font = [UIFont fontWithName:@"Helvetica" size:24];
    pickerLabel.text = [NSString stringWithFormat:@" %@ˢ",[pickerValues objectAtIndex:row]];
    pickerLabel.backgroundColor = [UIColor clearColor];
    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    baseNumber = row;
    baseNumberLabel.text = [NSString stringWithFormat:@"%i",baseNumber];
}
#pragma mark ######################################################################################################################
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    baseNumberLabel = nil;
    iLabel = nil;
    answerLabel = nil;
    operatorLabel = nil;
    picker = nil;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ######################################################################################################################





@end