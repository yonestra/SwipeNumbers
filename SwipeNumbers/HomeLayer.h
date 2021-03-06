//
//  HomeLayer.h
//  SwipeNumbers
//
//  Created by 米澤 翔太 on 12/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GADBannerView.h"
#import <GameKit/GameKit.h>
#import "GameKitHelper.h"

@interface HomeLayer : CCLayer <GADBannerViewDelegate, GKLeaderboardViewControllerDelegate, GameKitHelperProtocol> {
    GADBannerView *_bannerView;
}

+(CCScene *)scene;

@end
