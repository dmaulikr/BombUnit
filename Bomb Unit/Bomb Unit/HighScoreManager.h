//
//  HighScoreManager.h
//  Bomb Unit
//
//  Created by Erran Carey on 4/22/12.
//  Copyright (c) 2012 App2O. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GKLeaderboard, GKAchievement, GKPlayer;

@protocol HighscoreManagerDelegate <NSObject>
@optional
- (void) processGameCenterAuth: (NSError*) error;
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
- (void) achievementResetResult: (NSError*) error;
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
@end

@interface HighScoreManager : NSObject
{
	NSMutableDictionary* earnedAchievementCache;
	
	id <HighscoreManagerDelegate, NSObject> delegate;
}

//This property must be attomic to ensure that the cache is always in a viable state...
@property (retain) NSMutableDictionary* earnedAchievementCache;

@property (nonatomic, assign)  id <HighscoreManagerDelegate> delegate;

+ (BOOL) isGameCenterAvailable;

- (void) authenticateLocalUser;

- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
- (void) reloadHighScoresForCategory: (NSString*) category;

- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete;
- (void) resetAchievements;

- (void) mapPlayerIDtoPlayer: (NSString*) playerID;
@end