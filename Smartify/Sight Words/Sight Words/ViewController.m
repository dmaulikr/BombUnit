//
//  ViewController.m
//  Sight Words
//
//  Created by Erran Carey on 3/30/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import "ViewController.h"


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




@interface ViewController ()

@end

@implementation ViewController


@synthesize sightWord;
@synthesize sightWords;
@synthesize sightWordLabel;
@synthesize categories;
@synthesize label;
@synthesize picker;
//@synthesize sightWordSound;
@synthesize sightWordButton;
@synthesize isRandom;
@synthesize isRandomLabel;

@synthesize goButton;

@synthesize index;
@synthesize index_old;

@synthesize logo;


-(void)go{
    if(isRandom.on == YES){
        self.index = 0 + arc4random() % (self.sightWords.count - 0);
        
    }
    else if(isRandom.on = NO){
        self.index = 0;
    }
    [self sightWordShown];
    [self updateLabel];
    sightWordLabel.hidden = NO;
    label.hidden = YES;
    picker.hidden = YES;
    isRandomLabel.hidden = YES;
    [goButton setImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    sightWordButton.hidden = NO;
    isRandom.hidden = YES;
    logo.hidden = YES;
}
-(void)stop{
        self.index = 0;
        [self sightWordShown];
        [self updateLabel];
        sightWordLabel.hidden = YES;
        label.hidden = NO;
        picker.hidden = NO;
        sightWordButton.hidden = YES;
        isRandomLabel.hidden = NO;
        [goButton setImage:[UIImage imageNamed:@"go.png"] forState:UIControlStateNormal];
        logo.hidden = NO;
        isRandom.hidden = NO;
}

-(IBAction)go_Stop{
    if(sightWordLabel.hidden == YES)
        [self go];
    else if(sightWordLabel.hidden == NO)
        [self stop];
}
/*
-(IBAction)sightWordPressed{
    [self.sightWordSound play];
}
*/
-(void)sightWordShown{
    sightWord = [self.sightWords objectAtIndex:self.index];
    sightWordLabel.text = [self.sightWords objectAtIndex:self.index];
    //NSString *sightWordPath = [[NSBundle mainBundle] pathForResource:sightWord ofType:@"mp3"];
    //self.sightWordSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:sightWordPath] error:NULL];
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
}

-(void)increment{
    if(isRandom.on == YES){
        self.index_old = self.index;
        self.index = 0 + arc4random() % (self.sightWords.count - 0);
        if (index == index_old) {
            self.index = 0 + arc4random() % (self.sightWords.count - 0);

        }
    }
    else {
        self.index++;
    }
}

-(void)decrement{
    if(isRandom.on == YES){
        self.index_old = self.index;
        self.index = 0 + arc4random() % (self.sightWords.count - 0);
        if (index == index_old) {
            self.index = 0 + arc4random() % (self.sightWords.count - 0);
        }
    }
    else {
        self.index--;
    }
}
-(void)forward{
    if(index < [self.sightWords count]-1 && sightWordLabel.hidden == NO && isRandom.on == NO){
        [self increment];
        [self startForwardAnimation];
        [UIView commitAnimations];
        [self sightWordShown];
    }
    else if(index < [self.sightWords count]-1 && sightWordLabel.hidden == NO && isRandom.on == YES){
        [self increment];
        [self startForwardAnimation];
        [UIView commitAnimations];
        [self sightWordShown];
    }
    else if(index == [self.sightWords count]-1 && isRandom.on == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smartify" message:@"This is the last flash card." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
        [alert release];

    }
}
-(void)back{
    if(index > 0 && sightWordLabel.hidden == NO){
        [self decrement];
        [self startBackwardAnimation];
        [UIView commitAnimations];
        [self sightWordShown];
    }
    else if(index == 0 && sightWordLabel.hidden == NO && isRandom.on == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smartify" message:@"This is the first flash card." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        alert.tag = 2;
        [alert show];
        [alert release];
        
    }
}
- (void)leftSwiped:(UIGestureRecognizer *)recognizer {
    [self forward];
}
- (void)rightSwiped:(UIGestureRecognizer *)recognizer {
    [self back];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    categories =  [[NSArray alloc] initWithObjects:@"Pre-Primer",@"Primer",@"1st Grade",@"2nd Grade",@"3rd Grade",@"Nouns",nil];

    sightWords = [[NSArray alloc] initWithObjects:@"a", @"and", @"away", @"big", @"blue", @"can", @"come", @"down", @"find", @"for", @"funny", @"go", @"help", @"here", @"I", @"in", @"is", @"it", @"jump", @"little", @"look", @"make", @"me", @"my", @"not", @"one", @"play", @"red", @"run", @"said", @"see", @"the", @"three", @"to", @"two", @"up", @"we", @"where", @"yellow", @"you",nil];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 120.0, 320.0, 120.0)]; 
    [self.view addSubview:picker];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.showsSelectionIndicator = YES;

    [self sightWordShown];
    
    [left release];
    [right release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc{
    [super dealloc];
    [picker release];
}

//Picker stuff
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [categories count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [categories objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0) {
        sightWords = [[NSArray alloc] initWithObjects:@"a", @"and", @"away", @"big", @"blue", @"can", @"come", @"down", @"find", @"for", @"funny", @"go", @"help", @"here", @"I", @"in", @"is", @"it", @"jump", @"little", @"look", @"make", @"me", @"my", @"not", @"one", @"play", @"red", @"run", @"said", @"see", @"the", @"three", @"to", @"two", @"up", @"we", @"where", @"yellow", @"you",nil];
    }
    if (row == 1) {
        sightWords = [[NSArray alloc] initWithObjects:@"all", @"am", @"are", @"at", @"ate", @"be", @"black", @"brown", @"but", @"came", @"did", @"do", @"eat", @"four", @"get", @"good", @"have", @"he", @"into", @"like", @"must", @"new", @"no", @"now", @"on", @"our", @"out", @"please", @"pretty", @"ran", @"ride", @"saw", @"say", @"she", @"so", @"soon", @"that", @"there", @"they", @"this", @"too", @"under", @"want", @"was", @"well", @"went", @"what", @"white", @"who", @"will", @"with", @"yes",nil];
    }
    if (row == 2) {
        sightWords = [[NSArray alloc] initWithObjects:@"after", @"again", @"an", @"any", @"as", @"ask", @"by", @"could", @"every", @"fly", @"from", @"give", @"giving", @"had", @"has", @"her", @"him", @"his", @"how", @"just", @"know", @"left", @"let", @"live", @"may", @"of", @"old", @"once", @"open", @"over", @"put", @"right", @"round", @"some", @"stop", @"take", @"thank", @"them", @"then", @"think", @"walk", @"were", @"when",nil];
    }
    if (row == 3) {
        sightWords = [[NSArray alloc] initWithObjects:@"always", @"around", @"because", @"been", @"before", @"best", @"both", @"buy", @"call", @"cold", @"does", @"don't", @"fast", @"first", @"five", @"found", @"gave", @"goes", @"green", @"its", @"made", @"many", @"off", @"or", @"pull", @"read", @"right", @"sing", @"sit", @"sleep", @"tell", @"their", @"these", @"those", @"upon", @"us", @"use", @"very", @"wash", @"which", @"why", @"wish", @"work", @"would", @"write", @"your",nil];
    }
    if (row == 4) {
        sightWords = [[NSArray alloc] initWithObjects:@"about", @"better", @"bring", @"carry", @"clean", @"cut", @"done", @"draw", @"drink", @"eight", @"fall", @"far", @"full", @"got", @"grow", @"hold", @"hot", @"hurt", @"if", @"keep", @"kind", @"laugh", @"light", @"long", @"much", @"myself", @"never", @"only", @"own", @"pick", @"seven", @"shall", @"show", @"six", @"small", @"start", @"ten", @"today", @"together", @"try", @"warm",nil];
    }
    if (row == 5) {
        sightWords = [[NSArray alloc] initWithObjects:@"apple", @"baby", @"back", @"ball", @"bear", @"bed", @"bell", @"bird", @"birthday", @"boat", @"box", @"boy", @"bread", @"brother", @"cake", @"car", @"cat", @"chair", @"chicken", @"children", @"Christmas", @"coat", @"corn", @"cow", @"day", @"dog", @"doll", @"door", @"duck", @"egg", @"eye", @"farm", @"farmer", @"father", @"feet", @"fire", @"fish", @"floor", @"flower", @"game", @"garden", @"girl", @"good-bye", @"grass", @"ground", @"hand", @"head", @"hill", @"home", @"horse", @"house", @"kitty", @"leg", @"letter", @"man", @"men", @"milk", @"money", @"morning", @"mother", @"name", @"nest", @"night", @"paper", @"party", @"picture", @"pig", @"rabbit", @"rain", @"ring", @"robin", @"Santa Claus", @"school", @"seed", @"sheep", @"shoe", @"sister", @"snow", @"song", @"squirrel", @"stick", @"street", @"sun", @"swipe", @"table", @"thing", @"time", @"top", @"toy", @"tree", @"watch", @"water", @"way", @"wind", @"window", @"wood",nil];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
        UILabel *pickerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(160.0, 120.0, 280.0, 120.0)] autorelease];
        pickerLabel.text = [NSString stringWithFormat:@"%@",[categories objectAtIndex:row]];
        pickerLabel.font = [UIFont fontWithName:@"Helvetica" size:24];
       // UIColor *bluish = UIColorFromRGB(0x0099CC);    
       // pickerLabel.textColor = bluish;
        pickerLabel.backgroundColor = [UIColor clearColor];
        return pickerLabel;
}

@end