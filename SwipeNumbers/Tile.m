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
@synthesize delegate = _delegate;

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
    
    // ハイライト用フレームを用意
    highlightedFrame = [[CCSprite alloc] initWithFile:@"burst_09.png"];
    highlightedFrame.color = ccc3(255, 0, 0);
    highlightedFrame.position = CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2);
    highlightedFrame.opacity = 127;
    [self addChild:highlightedFrame z:3];
    highlightedFrame.visible = NO;

}

- (void)onExit {
    [super onExit];
    
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeDelegate:self];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL bResult = NO;
    
    if ([self containsTouchLocation:touch]) {
        CCLOG(@"ccTouchBegan![%d]", _positionId);
        if ([_delegate respondsToSelector:@selector(tileTapAtIndex:)]) {
            [_delegate tileTapAtIndex:_positionId];
        }
        // ハイライトフレームを表示
        [self setHighlighted:YES];
        
        // タッチ開始フラグをON
        bResult = YES;
    }
    
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {

}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {

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


#pragma mark -
#pragma mark Animation

- (void)disappearWithAnimation:(BOOL)animated {
    // 画像をアニメーション用のに切り替える
    
    NSArray *fileNames  = [NSArray arrayWithObjects:
                           @"burst_01.png",
                           @"burst_02.png",
                           @"burst_03.png",
                           @"burst_04.png",
                           @"burst_05.png",
                           @"burst_06.png",
                           @"burst_07.png",
                           @"burst_08.png",
                           @"burst_09.png",
                           @"burst_10.png",
                           @"burst_11.png",
                           @"burst_12.png",
                           nil];
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(NSString *fileName in fileNames){
        CCTexture2D * animTexture = [[CCTextureCache sharedTextureCache] addImage:fileName];
        CGSize size = [animTexture contentSize];
        CGRect rect = CGRectMake(-7.5, -7.5, size.width+15, size.height+15);
        CCSpriteFrame * frame = [CCSpriteFrame frameWithTexture:animTexture rect:rect];
        
        [walkAnimFrames addObject:frame];
    }
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f ];
    CCAnimate *animate  = [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO];
//    self.animation = [[CCRepeatForever actionWithAction:animate] retain];
    
    [self runAction:animate];
}

// ハイライト状態を変更する
- (void)setHighlighted:(BOOL)highlighted {
    highlightedFrame.visible = highlighted;
}


@end
