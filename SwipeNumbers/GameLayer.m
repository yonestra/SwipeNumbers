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
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self
                                                            priority:-9
                                                     swallowsTouches:YES
     ];
    
    // レイアウトの初期化
    [self initLayout];
    
    // タイル配列を初期化
    tileList = [[CCArray alloc] initWithCapacity:NUMBER_OF_READY_FOR_TILES];
    
    // タイルを配置
    [self arrangeTiles];
    
    // 時間計測スタート
    [self startTimer];
}

- (void)onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
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
    for (int i=0; i<NUMBER_OF_READY_FOR_TILES; i++) {
        
        // 1~6の数字を作る
        int randValue = random()%6 + 1;
        
        // タイルオブジェクトを作る
        NSString *file = [NSString stringWithFormat:@"dice_%d.png", randValue];
        Tile* tile = [[Tile alloc] initWithFile:file];
        tile.position = CGPointMake(TILESIZE*(i%7)+TILESIZE/2+MARGIN_LEFT, TILESIZE*(i/7)+TILESIZE/2+80);
        tile.positionId = i;        // 位置番号
        tile.value = randValue;     // サイコロの値
        [tileList addObject:tile];  // リストに持っておく
        
        // レイヤーに追加
        [self addChild:tile z:1];
    }
}


// タイルが選択された時
- (void)tileSelectAt:(Tile*)tappedTile {
    
    // 現在の数値をカウント. 既にカウント済のタイルは無視する（二重なぞり無視）
    if (tappedTile.isHighlighted == NO) {
        currentSelectTotalPoint += tappedTile.value;
    }
    
    // タップされたタイルをハイライト表示
    [tappedTile setHighlighted:YES];
    
    // ちょうど10になってるかチェック
    if (self.isCurrentPointCheck == CURRENT_POINT_JUST_TEN) {
        ////// ちょうど10の場合 //////
        
        // 選択中のタイルを爆発させる（全タイルにNotificationを送る）
        // TODO: つくる
        [self burstSelectedTiles];
        
        // 選択全解除（念のため）
        [self highlightOffAllTiles];
        
        // ポイントを付与する（ロジック+ラベルを更新）
        // TODO: つくる
        
        // currentSelectTotalPointを0に戻す
        currentSelectTotalPoint = 0;
    }
    else if (self.isCurrentPointCheck == CURRENT_POINT_OVER_TEN) {
        ////// 10をこえちゃった場合 //////
        
        // 選択全解除
        [self highlightOffAllTiles];
        
        // currentSelectTotalPointを0に戻す
        currentSelectTotalPoint = 0;
        
    }
    else if (self.isCurrentPointCheck == CURRENT_POINT_UNDER_TEN) {
        ////// 10より小さい場合 //////
        
        // 何もしない
    }
}


// positionIdのタイルの位置に爆発アニメーションを表示する
// TODO: Tile側に持たせる
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



// タイマーを走らせる
- (void)startTimer{
    NSTimer* tm = [NSTimer
          scheduledTimerWithTimeInterval:1
          target:self
          selector:@selector(countTimer)
          userInfo:nil
          repeats:YES
          ];
}

// 時間計測用メソッド. 1秒ごとに呼ばれる
- (void)countTimer {
    currentTimerCount++;
    
    // せり上がりチェック（レベルによってタイミングは異なる）
    if (self.isAddTileLine) {
        // せり上がらせる（一列追加する）
        [self addTileLine];
    }
}

// 最下段にタイルを一列追加する
- (void)addTileLine {
    // TODO: 一列追加の処理
    
    // タイマーカウンタを初期化
    currentTimerCount = 0;
}

// タイマーカウンタを見て、ブロックを追加するタイミングかをチェックする
- (BOOL)isAddTileLine {
    // TODO: レベルの考慮
    if (currentTimerCount%10 == 0) {
        // とりあえず、10秒毎に一列追加する
        return YES;
    }
    return NO;
}

// 現在なぞり中のサイコロの合計値のステータスをチェック
// 10より小さい or 10 or 10より大きい
- (int)isCurrentPointCheck {
    if (currentSelectTotalPoint < 10) {
        return CURRENT_POINT_UNDER_TEN;
    } else if (currentSelectTotalPoint == 10) {
        return CURRENT_POINT_JUST_TEN;
    } else {
        return CURRENT_POINT_OVER_TEN;
    }
}

// タッチした領域に衝突するタイルを探す
- (void)collesionTileAction:(UITouch*)touch {
    for (Tile* tile in tileList) {
        BOOL result = [tile containsTouchLocation:touch];
        if (result) {
            // 衝突したタイルを選択状態にする
            [self tileSelectAt:tile];
            return;
        }
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self collesionTileAction:touch];
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    [self collesionTileAction:touch];
}

- (void)ccTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // 離したら全て解除
    [self highlightOffAllTiles];
    currentSelectTotalPoint = 0;
}

- (void)ccTouchCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // 離したら全て解除
    [self highlightOffAllTiles];
    currentSelectTotalPoint = 0;
}

// 全てのタイルのハイライトをOFF状態にする
- (void)highlightOffAllTiles {
    for (Tile* tile in tileList) {
        [tile setHighlighted:NO];
    }
}

// 選択中のタイルを全て爆発させる
- (void)burstSelectedTiles {
    for (Tile* tile in tileList) {
        if (tile.isHighlighted) {
            [tile burstWithAnimation];
        }
    }
}

@end
