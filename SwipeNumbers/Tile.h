//
//  Tile.h
//  SwipeNumbers
//
//  Created by 平松 亮介 on 2012/12/23.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Tile : CCSprite <CCTargetedTouchDelegate>

@property (nonatomic, assign) int positionId;

@end
