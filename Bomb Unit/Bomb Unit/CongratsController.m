//
//  CongratsController.m
//  Bomb Unit
//
//  Created by Erran Carey on 4/25/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import "CongratsController.h"
#import "ViewController.h"

@interface CongratsController ()

@end

@implementation CongratsController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self songPlay];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(IBAction)switchView:(id)sender{
    [song stop];
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"help"];
    [self presentModalViewController:viewController animated:YES];
    

}
-(void)songPlay{
    NSError *error = nil;
    NSURL *noiseURL = [[NSBundle mainBundle] URLForResource:@"Tjaere_Igjen" withExtension:@"mp3"];  
    song = [[AVAudioPlayer alloc] initWithContentsOfURL:noiseURL error:&error];
    [song play];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end