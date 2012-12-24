//
//  GameLayer.h
//  SwipeNumbers
//
//  Created by 米澤 翔太 on 12/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Tile.h"

@interface GameLayer : CCLayer <TileTapDelegate> {
    CCArray* tileList;
    CCAnimate *animate;
    int currentCount;
}

@property (nonatomic, retain) CCAnimate *animation;
@property (nonatomic, readonly) BOOL isAddTileLine;

+(CCScene *)scene;

@end
