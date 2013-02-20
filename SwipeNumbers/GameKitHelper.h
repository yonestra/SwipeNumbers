//
//  GameKitHelper.h
//  SwipeNumbers
//
//  Created by 米澤 翔太 on 1/30/13.
//
//

#import "cocos2d.h"

#import <GameKit/GameKit.h>

@protocol GameKitHelperProtocol <NSObject>

-(void)onScoresSubmitted:(BOOL)success;
-(void)onLeaderboardViewDismissed;

@end

@interface GameKitHelper : UIViewController <GKLeaderboardViewControllerDelegate>
{
    
}

@property (nonatomic, retain) id<GameKitHelperProtocol> delegate;
@property (nonatomic, readonly) bool isGameCenterAvailable;
@property (nonatomic, readonly) NSError* lastError;

+(GameKitHelper*)sharedGameKitHelper;
-(void) submitScore:(int64_t)score category:(NSString*)category;
-(void) showLeaderboard;

@end
