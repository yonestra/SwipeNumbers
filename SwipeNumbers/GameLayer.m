//
//  GameLayer.m
//  SwipeNumbers
//
//  Created by 米澤 翔太 on 12/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

@implementation GameLayer
@synthesize animation = _animation;
@synthesize isAddTileLine = _isAddTileLine;
@synthesize isCurrentPointCheck = _isCurrentPointCheck;

+(CCScene *)scene
{
    CCScene *scene = [CCScene node];
    GameLayer *layer = [GameLayer node];
    [scene addChild:layer];
    
    return scene;
}

// 変数を初期化
- (id)init {
    self = [super init];
    if (self) {
        // Initialize
        currentTimerCount = 0;
        currentSelectTotalPoint = 0;
        _isAddTileLine = NO;
        _isCurrentPointCheck = CURRENT_POINT_UNDER_TEN;
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    
    // タッチイベントを拾うように設定
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:-9 swallowsTouches:YES];
    
    // レイアウトの初期化
    [self initLayout];
    
    // タイル配列を初期化
    tileList = [[CCArray alloc] initWithCapacity:49];
    
    // タイルを配置
    [self arrangeTiles];
    
    // 爆発アニメーションを準備
    [self readyBurstAnimation];
    
    // 時間計測スタート
    [self startTimer];
}

// レイアウト初期化メソッド。コンポーネントの初期化・配置を担う
- (void)initLayout {
    // スコアラベル
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Score 20,000pt" fontName:@"Arial-BoldMT" fontSize:20];
    scoreLabel.position = CGPointMake(80, self.contentSize.height - 20);
    scoreLabel.color = ccc3(255, 100, 40);
    [self addChild:scoreLabel z:1];
    
    // せり上がる迄のカウントダウン
    CCLabelTTF *countDownLabel = [CCLabelTTF labelWithString:@"0:02" fontName:@"Arial-BoldMT" fontSize:20];
    countDownLabel.position = CGPointMake(200, self.contentSize.height - 20);
    countDownLabel.color = ccc3(255, 100, 40);
    [self addChild:countDownLabel z:1];
    
    // 現在選択中のサイの合計値
    CCLabelTTF *selectCount = [CCLabelTTF labelWithString:@"8/10" fontName:@"Arial-BoldMT" fontSize:30];
    selectCount.position = CGPointMake(280, self.contentSize.height - 20);
    selectCount.color = ccc3(255, 255, 255);
    [self addChild:selectCount z:1];
}


// 画面いっぱい(49枚)のタイルを作って並べる
- (void)arrangeTiles {
    // タイルを作成
    for (int i=0; i<49; i++) {
        int randValue = random()%6 + 1; // 1~6の数字を使う
        NSString *file = [NSString stringWithFormat:@"dice_%d.png", randValue];
        Tile* tile = [[Tile alloc] initWithFile:file];
        tile.position = CGPointMake(45*(i%7)+27.5+2.5, 45*(i/7)+27.5+80);
        tile.positionId = i;
        tile.value = randValue;
        tile.delegate = self;
        [tileList addObject:tile];
        
        // レイヤーに追加
        [self addChild:tile z:1];
    }
}

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


//#pragma mark -
//#pragma mark TileTapDelegate
//
//// タイルがタップされた時
//- (void)tileTapAtIndex:(int)positionId {
//    Tile *tappedTile = [tileList objectAtIndex:positionId];
//    
//    // タップされたタイルをハイライト表示
//    [tappedTile setHighlighted:YES];
//    
//    // 現在の数値を数える
//    if (tappedTile.isHighlighted == NO) {
//        currentSelectTotalPoint += tappedTile.value;
//    }
//    
//    // ちょうど10になってるかチェック
//    if (self.isCurrentPointCheck == CURRENT_POINT_JUST_TEN) {
//        // 選択中のタイルを爆発させる（全タイルにNotificationを送る）
//        // ポイントを付与する（ロジック+ラベルを更新）
//        // currentSelectTotalPointを0に戻す
//    }
//    else if (self.isCurrentPointCheck == CURRENT_POINT_OVER_TEN) {
//        // エラー！
//        // 10を超えてしまったら全解除
//        [self highlightOffAllTiles];
//        
//        // currentSelectTotalPointを0に戻す
//        currentSelectTotalPoint = 0;
//        
//    }
//    else if (self.isCurrentPointCheck == CURRENT_POINT_UNDER_TEN) {
//        // 何もしない
//    }
//}

// タイルが選択された時
- (void)tileSelectAt:(Tile*)tappedTile {
    
    // 現在の数値を数える
    if (tappedTile.isHighlighted == NO) {
        currentSelectTotalPoint += tappedTile.value;
    }
    
    // タップされたタイルをハイライト表示
    [tappedTile setHighlighted:YES];
    
    
    // ちょうど10になってるかチェック
    if (self.isCurrentPointCheck == CURRENT_POINT_JUST_TEN) {
        // 選択中のタイルを爆発させる（全タイルにNotificationを送る）
        
        // 選択全解除（念のため）
        [self highlightOffAllTiles];
        
        // ポイントを付与する（ロジック+ラベルを更新）
        // currentSelectTotalPointを0に戻す
        currentSelectTotalPoint = 0;
    }
    else if (self.isCurrentPointCheck == CURRENT_POINT_OVER_TEN) {
        // エラー！
        // 10を超えてしまったら全解除
        [self highlightOffAllTiles];
        
        // currentSelectTotalPointを0に戻す
        currentSelectTotalPoint = 0;
        
    }
    else if (self.isCurrentPointCheck == CURRENT_POINT_UNDER_TEN) {
        // 何もしない
    }
}


// positionIdのタイルの位置に爆発アニメーションを表示する
- (void)disappearTileAtIndex:(int)positionId {
    CCSprite *targetSprite = [tileList objectAtIndex:positionId];
    
    // 爆発を表示させる用のSpriteを用意する
    CCSprite *burstSprite = [[[CCSprite alloc] init] autorelease];
    burstSprite.position = targetSprite.position;
    [self addChild:burstSprite z:10];
    
    // positionIdのタイルを消す
    targetSprite.visible = NO;
    
    // 爆発アニメーションを開始
    [burstSprite runAction:animate];
    
    // TODO: アニメーションが終わったら消す処理（タイマー？）
}

// タイマースタート
- (void)startTimer{
    NSTimer* tm = [NSTimer
          scheduledTimerWithTimeInterval:1
          target:self // クラスを指定
          selector:@selector(countTimer)
          userInfo:nil
          repeats:YES
          ];
}

// 1秒ごとに呼ばれる
- (void)countTimer {
    currentTimerCount++;
    
    // せり上がりチェック（レベルによってスピードが異なる）
    if (self.isAddTileLine) {
        [self addTileLine];
    }
}

// 最下段にタイルを一列追加する
- (void)addTileLine {
    // TODO: 一列追加
    
    // カウンタを初期化
    currentTimerCount = 0;
}

// 現在のカウンタはブロックを追加するタイミングに相応しいかをチェックする
- (BOOL)isAddTileLine {
    // TODO: レベルを考慮して追加するかどうかを判断する
    if (currentTimerCount%10 == 0) {
        return YES;
    }
    return NO;
}

// 
- (int)isCurrentPointCheck {
    CCLOG(@"現在の値: %d", currentSelectTotalPoint);
    
    if (currentSelectTotalPoint < 10) {
        return CURRENT_POINT_UNDER_TEN;
    } else if (currentSelectTotalPoint == 10) {
        return CURRENT_POINT_JUST_TEN;
    } else {
        return CURRENT_POINT_OVER_TEN;
    }
}

// タッチした領域に衝突するタイルを探す
- (void)collesionTile:(UITouch*)touch {
    for (Tile* tile in tileList) {
        BOOL result = [tile containsTouchLocation:touch];
        if (result) {
            // 衝突したタイルを発見した場合
            [self tileSelectAt:tile];
            [tile setHighlighted:YES];
            return;
        }
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self collesionTile:touch];
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [self collesionTile:touch];
}

- (void)ccTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // 離したら全て解除
    [self highlightOffAllTiles];
}

- (void)ccTouchCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // 離したら全て解除
    [self highlightOffAllTiles];
}

// 全てのタイルのハイライトをOFF状態にする
- (void)highlightOffAllTiles {
    for (Tile* tile in tileList) {
        [tile setHighlighted:NO];
    }
}

@end
