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
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    menu.position = CGPointMake(winSize.width / 2, 60);
    [self addChild:menu];
}

@end
