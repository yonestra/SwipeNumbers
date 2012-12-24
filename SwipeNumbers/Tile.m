//
//  Tile.m
//  SwipeNumbers
//
//  Created by 平松 亮介 on 2012/12/23.
//
//

#import "Tile.h"

@implementation Tile

@synthesize positionId = _positionId;

- (id)init {
    if (self = [super init]) {
        _positionId = -1;
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:-9 swallowsTouches:YES];
    
    // 通知センターのオブザーバ登録
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(NotifyFromNoticationCenter:)
     name:nil
     object:nil];
}

- (void)onExit {
    [super onExit];
    
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeDelegate:self];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL bResult = NO;
    
    if ([self containsTouchLocation:touch]) {
//        CGPoint touchLocation = [touch locationInView:[touch view]];
        
        CCLOG(@"ccTouchBegan![%d]", _positionId);
        
        // タッチ開始フラグをON
        bResult = YES;
    }
    
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
//    // タッチ座標->cocos2d系
//    CGPoint touchLocation = [touch locationInView:[touch view]];
//    CGPoint currentTouchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
//    
//    // 一定値以上動いた場合、移動扱いとする
//    CGPoint difference = ccpSub(_touchLocation, currentTouchLocation);
//    float factor = 20;
//    if ((abs(difference.x)>factor) || (abs(difference.y)>factor)) {
//        // 移動を通知
//        NSDictionary* dic = [NSDictionary dictionaryWithObject:touch forKey:TILE_MSG_NOTIFY_TOUCH_MOVE];
//        [[NSNotificationCenter defaultCenter] postNotificationName:TILE_MSG_NOTIFY_TOUCH_MOVE object:self userInfo:dic];
//        
//        // 基準点を変更
//        _touchLocation = currentTouchLocation;
//    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
//    // 長押しスケジュール停止
//    [self unschedule:@selector(scheduleEventTouchHold:)];
//    
//    if (_isTouchBegin == YES) {
//        if ([self containsTouchLocation:touch]) {
//            if (_isTouchHold == NO) {
//                // タップ通知
//                [[NSNotificationCenter defaultCenter] postNotificationName:TILE_MSG_NOTIFY_TAP object:self];
//            }
//        }
//    }
//    
//    // タッチ終了を通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:TILE_MSG_NOTIFY_TOUCH_END object:self];
}

- (BOOL)containsTouchLocation:(UITouch *)touch {
    // UI座標系 -> GI座標系
    CGPoint touchLocation = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    CGRect boundingBox = self.boundingBox;
    
    CCNode* parent = self.parent;
    while (parent != nil) {
        if ([parent isKindOfClass:[CCLayer class]]) {
            break;
        }
        else {
            parent = parent.parent;
        }
    }
    
    if (parent != nil) {
        boundingBox.origin = ccpAdd(boundingBox.origin, parent.position);
    }
    
    return CGRectContainsPoint(boundingBox, location);
}

#pragma mark -
#pragma mark Setter/Getter

- (void)setPositionId:(int)positionId {
    _positionId = positionId;
    CCLOG(@"positionId set = %d", _positionId);
}

@end
