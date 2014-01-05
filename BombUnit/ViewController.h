//
//  ViewController.h
//  Bomb Unit
//
//  Created by Erran Carey on 4/21/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
#import "HighScoreManager.h"

@class HighScoreManager;

@interface ViewController  : UIViewController<AVAudioPlayerDelegate, UIAlertViewDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, HighscoreManagerDelegate> {
	NSUInteger hiddenLocation;
	NSTimer *clock;
	NSUInteger elapsed_seconds;
	AVAudioPlayer *caution;
	AVAudioPlayer *bomb;
	AVAudioPlayer *bombDiffused;
	AVAudioPlayer *phew;
    HighScoreManager *highscoreManager;
	int64_t  currentScore;
	NSString* currentLeaderBoard;
}

@property (nonatomic, assign) IBOutlet UIButton *robotButton;
@property (nonatomic, assign) IBOutlet UIButton *startButton;
@property (nonatomic, assign) IBOutlet UITextField *timeRemaining;
@property (nonatomic, assign) IBOutlet UILabel *level;
@property (nonatomic, assign) IBOutlet UILabel *triesLbl;
@property (nonatomic, assign) IBOutlet UIImageView *where;
@property (strong, nonatomic) IBOutlet UILabel *score;

@property (strong, nonatomic) NSArray *blastZone;
@property BOOL detonated;
@property int difficultLv;
@property int timebonus;
@property int tries;
@property int allowedTries;
@property int scoreInt;

- (IBAction)startGame:(id)sender;
- (void)guess:(id)sender;
- (void)tick:(NSTimer *)timer;
- (void)resetGame;
- (void)levelPassed;
- (void)gameover;
- (void)swapcolor;

- (void)checkSelection;
- (void)alertCongrats;
- (void)alertContinue;
- (void)konamiSkip;
- (void)alertGameOver;
- (void)alertStart;

// Game Center Junk:
@property (nonatomic, retain) HighScoreManager *highscoreManager;
@property (nonatomic, assign) int64_t currentScore;
@property (nonatomic, retain) NSString* currentLeaderBoard;

- (IBAction) showLeaderboard;
- (IBAction) showAchievements;
- (IBAction) submitScore;


- (void) checkAchievements;


@end
