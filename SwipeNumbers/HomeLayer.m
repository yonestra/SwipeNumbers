//
//  HomeLayer.m
//  SwipeNumbers
//
//  Created by 米澤 翔太 on 12/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeLayer.h"
#import "GameLayer.h"

@implementation HomeLayer

+(CCScene *)scene
{
    CCScene *scene = [CCScene node];
    HomeLayer *layer = [HomeLayer node];
    [scene addChild:layer];
    
    return scene;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGRect rect = CGRectMake(0, size.height - 50, 320, 50);
        _bannerView = [[GADBannerView alloc] initWithFrame:rect];
        _bannerView.adUnitID = MY_BANNER_UNIT_ID;
        _bannerView.rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        _bannerView.delegate = self;
        [[[CCDirector sharedDirector] view] addSubview:_bannerView];
        
        GADRequest *request = [GADRequest request];
        request.testing = NO;
        [_bannerView loadRequest:request];
    }
    
    return self;
}

-(void)adViewDidReceiveAd:(GADBannerView *)view
{
    printf("adViewDidReceiveAd\n");
}

-(void)onEnter
{
    [super onEnter];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
//    CCSprite *backImage = [CCSprite spriteWithFile:@"tsubakuro.jpg"];
//    backImage.position = CGPointMake(winSize.width / 2, winSize.height / 2);
//    backImage.color = ccc3(100, 100, 100);
//    [self addChild:backImage z:0];
    
    [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
    [CCMenuItemFont setFontSize:40];
    CCMenuItemFont *item = [CCMenuItemFont itemWithString:@"ゲームスタート" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene] withColor:ccWHITE]];
    }];
    item.position =CGPointMake(0, 90);
    CCMenuItemFont *item2 = [CCMenuItemFont itemWithString:@"ランキング" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene] withColor:ccWHITE]];
    }];
    item2.position =CGPointMake(0, 50);
    CCMenuItemFont *item3 = [CCMenuItemFont itemWithString:@"遊び方" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene] withColor:ccWHITE]];
    }];
    item3.position =CGPointMake(0, 10);
    CCMenu *menu = [CCMenu menuWithItems:item, item2, item3, nil];
    menu.position = CGPointMake(winSize.width / 2, 150);
    [self addChild:menu];
    
    
}

@end
