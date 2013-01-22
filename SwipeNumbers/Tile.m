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
@synthesize isHighlighted = _isHighlighted;
@synthesize delegate = _delegate;

// 変数の初期化
- (id)initWithFile:(NSString *)filename {
    if (self = [super initWithFile:filename]) {
        _positionId = -1;
        _value = 0;
        isBursting = NO;
        height = 0;
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
    
    // ゲームオーバ用フレームを用意
    gameOverFrame = [[CCSprite alloc] initWithFile:@"selected2.png"];
    gameOverFrame.position = CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2);
    gameOverFrame.opacity = 127;
    [self addChild:gameOverFrame z:4];
    gameOverFrame.visible = NO;
    
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
    
    NSArray *fileNames  = [NSArray arrayWithObjects:
                           @"burst_01.png",
                           @"burst_02.png",
                           @"burst_03.png",
                           @"burst_04.png",
                           @"burst_05.png",
                           @"burst_06.png",
                           @"burst_07.png",
                           nil];
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(NSString *fileName in fileNames){
        CCTexture2D * animTexture = [[CCTextureCache sharedTextureCache] addImage:fileName];
        CGSize size = [animTexture contentSize];
//        CGRect rect = CGRectMake(-7.5, -7.5, size.width+15, size.height+15);
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        CCSpriteFrame * frame = [CCSpriteFrame frameWithTexture:animTexture rect:rect];
        
        [walkAnimFrames addObject:frame];
    }
    CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.05f];
    animate  = [CCAnimate actionWithAnimation:walkAnim];
    
    //アニメのアクションをアクション実行用データに追加
    actBurst = [[CCSequence actions:animate, nil] retain];

}

// 爆発アニメーションを再生
- (void)burstWithAnimation {
    // 自身を消す
    highlightedFrame.visible = NO;
    
    // 爆発アニメーションを表示
    // TODO: CCActionManage: Assertion failureが出て落ちる
    // → 既に爆発アニメーション中は、無視するように設定
    if (isBursting == NO) {
        isBursting = YES;
        [self runAction:actBurst];
    }
    
    // 0.1秒後にオブジェクトを解放
    NSTimer *tm = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                   target:self
                                                 selector:@selector(removeSelf)
                                                 userInfo:NO
                                                  repeats:NO];

}

// 自分自身を消す
// TODO: 消す方法をこれに変える: http://hamasyou.com/blog/archives/000387
- (void)removeSelf {
    if ([_delegate respondsToSelector:@selector(removeTile:)]) {
        [_delegate removeTile:self];
    }
    [self removeFromParentAndCleanup:YES];
    isBursting = NO;
}

// ハイライト状態を変更する. YES:ハイライトする NO:ハイライトを消す
- (void)setHighlighted:(BOOL)highlighted {
    highlightedFrame.visible = highlighted;
}

// 自分がハイライト状態かどうかを返す
- (BOOL)isHighlighted {
    return highlightedFrame.visible;
}

// タイルを１つ上に移動. 移動後のpositionIdを返す
- (int)upTile {
    height += TILE_MOVE_UP_DELTA;
    if (height % 45 == 0) {
        _positionId += 7;   // ポジションIDを調整
    }
    
    self.position = CGPointMake(self.position.x, self.position.y + TILE_MOVE_UP_DELTA);

    return self.position.y;
}

// タイルを１つ下の列に移動
- (void)downTile {
    _positionId -= 7;
    self.position = CGPointMake(self.position.x, self.position.y - 45);
}

// タイルをゲームオーバー表示する
- (void)showGameOverTile {
    highlightedFrame.visible = NO;
    gameOverFrame.visible = YES;
}

@end
