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

@interface Tile : CCSprite  {
    CCSprite *highlightedFrame;
}

@property (nonatomic, assign) int positionId;
@property (nonatomic, assign) int value;
@property (nonatomic, readonly) BOOL isHighlighted;
@property (nonatomic, assign) id<TileTapDelegate> delegate;

- (BOOL)containsTouchLocation:(UITouch *)touch;
- (void)setHighlighted:(BOOL)highlighted;


@end
