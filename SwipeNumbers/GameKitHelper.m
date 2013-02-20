//
//  GameKitHelper.m
//  SwipeNumbers
//
//  Created by 米澤 翔太 on 1/30/13.
//
//

#import "GameKitHelper.h"

@implementation GameKitHelper

@synthesize delegate = _delegate;
@synthesize lastError = _lastError;
@synthesize isGameCenterAvailable = _isGameCenterAvailable;

static GameKitHelper *instanceOfGameKitHelper = nil;

+(id) alloc
{
    
    @synchronized(self)
    {
        
        NSAssert(instanceOfGameKitHelper == nil, @"Attempted to allocate a second instance of the singleton: GameKitHelper");
        
        instanceOfGameKitHelper = [[super alloc] retain];
        
        return instanceOfGameKitHelper;
    }
    
    return nil;
}

+(GameKitHelper*) sharedGameKitHelper
{
    
    @synchronized(self)
    {
        
        if (instanceOfGameKitHelper == nil)
        {
            
            [[GameKitHelper alloc] init];
            
        }
        
        return instanceOfGameKitHelper;
    }
    
    return nil;
}

-(id) init
{
    
    if ((self = [super init]))
    {
        
        // Test for Game Center availability
        
        Class gameKitLocalPlayerClass = NSClassFromString(@"GKLocalPlayer");
        
        bool isLocalPlayerAvailable = (gameKitLocalPlayerClass != nil);
        
        // Test if device is running iOS 4.1 or higher
        
        NSString* reqSysVer = @"4.1";
        
        NSString* currSysVer = [[UIDevice currentDevice] systemVersion];
        
        bool isOSVer41 = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
        
        _isGameCenterAvailable = (isLocalPlayerAvailable && isOSVer41);
        
        NSLog(@"GameCenter available = %@", _isGameCenterAvailable ? @"YES" : @"NO");
        
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
    
    CCLOG(@"dealloc %@", self);
    
    [instanceOfGameKitHelper release];
    
    instanceOfGameKitHelper = nil;
    
    [_lastError release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void) setLastError:(NSError*)error
{
    
    [_lastError release];
    
    _lastError = [error copy];
    
    if (_lastError)
    {
        
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo] description]);
        
    }
}

-(void) authenticateLocalPlayer
{
    
    if (_isGameCenterAvailable == NO)
        return;
    
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.authenticated == NO)
    {
        
        [localPlayer authenticateWithCompletionHandler:^(NSError* error)
        {
            
            [self setLastError:error];
            
            if (error == nil)
            {
                
            }
            
        }];
    }
}

-(void) submitScore:(int64_t)score category:(NSString*)category
{
    
    if (_isGameCenterAvailable == NO)
        return;
    
    GKScore* gkScore = [[[GKScore alloc] initWithCategory:category] autorelease];
    
    gkScore.value = score;
    
    [gkScore reportScoreWithCompletionHandler:^(NSError* error)
    {
        
        [self setLastError:error];
        
        bool success = (error == nil);
        
        [_delegate onScoresSubmitted:success];
    }];
}


// Leaderboards

-(void) showLeaderboard
{
    
    if (_isGameCenterAvailable == NO)
        return;
    
    GKLeaderboardViewController* leaderboardVC = [[[GKLeaderboardViewController alloc] init] autorelease];
    
    if (leaderboardVC != nil)
    {
        
        leaderboardVC.leaderboardDelegate = self;
        
        [self presentModalViewController:leaderboardVC animated:YES];
    }
}


-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController
{
    
    [self dismissModalViewControllerAnimated:YES];
    
    [_delegate onLeaderboardViewDismissed];
    
}

@end
