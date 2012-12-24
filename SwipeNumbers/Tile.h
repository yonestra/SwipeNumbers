//
//  Tile.h
//  SwipeNumbers
//
//  Created by 平松 亮介 on 2012/12/23.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol TileTapDelegate <NSObject>

- (void)tileTapAtIndex:(int)positionId;

@end

@interface Tile : CCSprite <CCTargetedTouchDelegate> {
    CCSprite *highlightedFrame;
}

@property (nonatomic, assign) int positionId;
@property (nonatomic, assign) id<TileTapDelegate> delegate;

- (void)setHighlighted:(BOOL)highlighted;

@end
