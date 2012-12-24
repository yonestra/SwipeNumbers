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
@synthesize value = _value;
@synthesize isHighlighted =_isHighlighted;

// 変数の初期化
- (id)init {
    if (self = [super init]) {
        _positionId = -1;
        _value = 0;
    }
    return self;
}

- (void)dealloc {
    [highlightedFrame release], highlightedFrame = nil;
    [animate release], animate = nil;
    [super dealloc];
}

-(void)onEnter {
    [super onEnter];
        
    // ハイライト用フレームを用意
    highlightedFrame = [[CCSprite alloc] initWithFile:@"selected.png"];
    highlightedFrame.position = CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2);
    highlightedFrame.opacity = 127;
    [self addChild:highlightedFrame z:3];
    highlightedFrame.visible = NO;
    
    // 爆発アニメーションを用意
    [self readyBurstAnimation];
}

// 衝突判定. タッチされた対象が自分であるかどうかを判断する
// cocos2dの本にあったものをそのまま引用
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
#pragma mark Animation

// 爆発アニメーションを用意する
- (void)readyBurstAnimation {
    // 画像をアニメーション用のに切り替える
    
    // 最後にブランクイメージを入れる？
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
        CCLOG(@"%@", frame);
        
        [walkAnimFrames addObject:frame];
    }
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f ];
    animate  = [[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO] retain];
}

// 爆発アニメーションを再生
- (void)burstWithAnimation {
    // 自身を消す
    self.visible = NO;
    highlightedFrame.visible = NO;
    
    // 爆発アニメーションを表示
    // TODO: CCActionManage: Assertion failureが出て落ちる
//    [self runAction:animate];
}

// ハイライト状態を変更する. YES:ハイライトする NO:ハイライトを消す
- (void)setHighlighted:(BOOL)highlighted {
    highlightedFrame.visible = highlighted;
}

// 自分がハイライト状態かどうかを返す
- (BOOL)isHighlighted {
    return highlightedFrame.visible;
}

@end
