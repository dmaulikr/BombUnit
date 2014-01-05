//
//  HelpController.m
//  Bomb Unit
//
//  Created by Erran Carey on 4/25/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import "HelpController.h"
#import "HighScoreManager.h"
#import "ViewController.h"
#import "AppSpecificValues.h"

@interface HelpController ()

@end

@implementation HelpController

@synthesize upSwipes;
@synthesize downSwipes;
@synthesize leftSwipes;
@synthesize rightSwipes;
@synthesize bBool;
@synthesize aBool;
@synthesize b;
@synthesize a;
@synthesize gamepad;
@synthesize konamiInt;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    highscoreManager = [[[HighScoreManager alloc] init] autorelease];
    HighScoreManager.delegate = self;
    [highscoreManager authenticateLocalUser];

    upSwipes = 0;
    downSwipes = 0;
    leftSwipes = 0;
    rightSwipes = 0;
    bBool = 0;
    aBool = 0;
    konamiInt = 0;
    [self addRecognizers];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)addRecognizers{
    UISwipeGestureRecognizer *up = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwiped:)] autorelease];
    UISwipeGestureRecognizer *down = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwiped:)] autorelease];
    UISwipeGestureRecognizer *left = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwiped:)] autorelease];
    UISwipeGestureRecognizer *right = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwiped:)] autorelease];
    up.direction = UISwipeGestureRecognizerDirectionUp;
    down.direction = UISwipeGestureRecognizerDirectionDown;
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:up];
    [self.view addGestureRecognizer:down];
    [self.view addGestureRecognizer:left];
    [self.view addGestureRecognizer:right];
}
- (void)upSwiped:(UIGestureRecognizer *)recognizer {
    if (downSwipes == 0 && leftSwipes == 0 && rightSwipes == 0){
        upSwipes++;
    }
    else {
        upSwipes = 0;
        downSwipes = 0;
        leftSwipes = 0;
        rightSwipes = 0;
    }
}
- (void)downSwiped:(UIGestureRecognizer *)recognizer {
    if (upSwipes == 2 && leftSwipes == 0 && rightSwipes == 0){
        downSwipes++;
    }
    else {
        [self toggleGamepad];
    }
}

- (void)leftSwiped:(UIGestureRecognizer *)recognizer {
    if (downSwipes == 2 && upSwipes == 2 && rightSwipes == 0){
        leftSwipes++;
    }
    else if (downSwipes == 2 && upSwipes == 2 && rightSwipes == 1 && leftSwipes == 1) {
        leftSwipes++;
    }
    else {
        [self toggleGamepad];
    }
}

- (void)rightSwiped:(UIGestureRecognizer *)recognizer {
    if (downSwipes == 2 && upSwipes == 2 && rightSwipes == 0){
        rightSwipes++;
    }
    else if (downSwipes == 2 && upSwipes == 2 && rightSwipes == 1 && leftSwipes == 2) {
        rightSwipes++;
        [self toggleGamepad];
    }
    else {
        [self toggleGamepad];
    }
}

- (IBAction)bPressed{
    if(aBool == 0){
        bBool = 1;
    }
}
- (IBAction)aPressed{
    if (bBool == 1) {
        aBool = 1;
        [self konami];
    }
    else {
        gamepad.hidden = YES;
        b.hidden = YES;
        a.hidden = YES;
    }
}
-(void)konami{
    konamiInt++;
    gamepad.hidden = YES;
    b.hidden = YES;
    a.hidden = YES;
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Greetings Ninja" message:@"Would you like to skip to Level 12?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease];
    [alert show];
}

- (void)toggleGamepad{
    if (upSwipes == 2 && downSwipes == 2 && leftSwipes == 2 && rightSwipes == 2) {
        gamepad.hidden = NO;
        b.hidden = NO;
        a.hidden = NO;
    }
    upSwipes = 0;
    downSwipes = 0;
    leftSwipes = 0;
    rightSwipes = 0;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Game Center Konami Code Achievement:
    if (buttonIndex == 1){
        NSString* identifier = NULL;
        double percentComplete = 0;
        switch(konamiInt){
            case 1:{identifier= kAchievementIDk; percentComplete= 100.0; break;}
            default: break;
        }
        if(identifier!= NULL){
            highscoreManager = [[[HighScoreManager alloc] init] autorelease];
            [highscoreManager setDelegate:self];
            [highscoreManager authenticateLocalUser];
            [highscoreManager submitAchievement: identifier percentComplete: percentComplete];
        }

        ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"gameplay"];
        [viewController konamiSkip];
        [self presentModalViewController:viewController animated:YES];
    }
}


@end
