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
@synthesize score = _score;
@synthesize currentTimerCount = _currentTimerCount;
@synthesize currentRestTimeCount = _currentRestTimeCount;
@synthesize currentSelectTotalPoint = _currentSelectTotalPoint;

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
        _currentTimerCount = 0;
        _currentSelectTotalPoint = 0;
        _score;
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
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial-BoldMT" fontSize:30];
    scoreLabel.position = CGPointMake(80, self.contentSize.height - 20);
    scoreLabel.color = ccc3(255, 100, 40);
    [self addChild:scoreLabel z:1];
    
    // せり上がる迄のカウントダウン
    countDownLabel = [CCLabelTTF labelWithString:@"0:10" fontName:@"Arial-BoldMT" fontSize:20];
    countDownLabel.position = CGPointMake(200, self.contentSize.height - 20);
    countDownLabel.color = ccc3(255, 100, 40);
    [self addChild:countDownLabel z:1];
    
    // 現在選択中のサイの合計値
    selectCountLabel = [CCLabelTTF labelWithString:@"0/10" fontName:@"Arial-BoldMT" fontSize:30];
    selectCountLabel.position = CGPointMake(280, self.contentSize.height - 20);
    selectCountLabel.color = ccc3(255, 255, 255);
    [self addChild:selectCountLabel z:1];
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
        tile.delegate = self;
        [tileList addObject:tile];  // リストに持っておく
        
        // レイヤーに追加
        [self addChild:tile z:1];
    }
}


// タイルが選択された時
- (void)tileSelectAt:(Tile*)tappedTile {
    
    // 現在の数値をカウント. 既にカウント済のタイルは無視する（二重なぞり無視）
    if (tappedTile.isHighlighted == NO) {
        self.currentSelectTotalPoint += tappedTile.value;
    }
    
    // タップされたタイルをハイライト表示
    [tappedTile setHighlighted:YES];
    
    // ちょうど10になってるかチェック
    if (self.isCurrentPointCheck == CURRENT_POINT_JUST_TEN) {
        ////// ちょうど10の場合 //////
        
        // 選択中のタイルを爆発させる（全タイルにNotificationを送る）
        // TODO: つくる
        [self burstSelectedTiles];
        
        // ポイントを付与する（ロジック+ラベルを更新）
        self.score += 10;
        
        // currentSelectTotalPointを0に戻す
        self.currentSelectTotalPoint = 0;

        isTouchStart = NO;
    }
    else if (self.isCurrentPointCheck == CURRENT_POINT_OVER_TEN) {
        ////// 10をこえちゃった場合 //////
        
        // 選択全解除
        [self highlightOffAllTiles];
        
        // currentSelectTotalPointを0に戻す
        self.currentSelectTotalPoint = 0;
        
        isTouchStart = NO;
    }
    else if (self.isCurrentPointCheck == CURRENT_POINT_UNDER_TEN) {
        ////// 10より小さい場合 //////
        
        // 何もしない
    }
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
    self.currentTimerCount++;
    CCLOG(@"timer[%d]", _currentTimerCount);
    
    // せり上がりチェック（レベルによってタイミングは異なる）
    if (self.isAddTileLine) {
        // せり上がらせる（一列追加する）
        [self addTileLine];
    }
}

// 最下段にタイルを一列追加する
- (void)addTileLine {
    // TODO: 一列追加の処理
    
    // 既存のタイルをせりあがらせる
    int maxTileHeight = [self upAllTiles];
    
    for (int i=0; i<7; i++) {
        // タイルオブジェクトを作る
        int randValue = random()%6 + 1;
        NSString *file = [NSString stringWithFormat:@"dice_%d.png", randValue];
        Tile* tile = [[Tile alloc] initWithFile:file];
        tile.position = CGPointMake(TILESIZE*(i%7)+TILESIZE/2+MARGIN_LEFT, TILESIZE*(i/7)+TILESIZE/2+80);
        tile.positionId = i;        // 位置番号
        tile.value = randValue;     // サイコロの値
        tile.delegate = self;
        [tileList addObject:tile];  // リストに持っておく
        [self addChild:tile];       // 画面に表示する
    }
    
    // ゲームオーバー判定
    if (maxTileHeight-1 > 7) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"まけ"
                              message:@"ゲームオーバー"
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    // タイマーカウンタを初期化
    self.currentTimerCount = 0;
}

// タイマーカウンタを見て、ブロックを追加するタイミングかをチェックする
- (BOOL)isAddTileLine {
    // TODO: レベルの考慮
    if (_currentTimerCount%10 == 0) {
        // とりあえず、10秒毎に一列追加する
        return YES;
    }
    return NO;
}

// 現在なぞり中のサイコロの合計値のステータスをチェック
// 10より小さい or 10 or 10より大きい
- (int)isCurrentPointCheck {
    if (_currentSelectTotalPoint < 10) {
        return CURRENT_POINT_UNDER_TEN;
    } else if (_currentSelectTotalPoint == 10) {
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
    isTouchStart = YES;
    [self collesionTileAction:touch];
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (isTouchStart) {
        [self collesionTileAction:touch];
    }
}

- (void)ccTouchEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // 離したら全て解除
    [self highlightOffAllTiles];
    self.currentSelectTotalPoint = 0;
    isTouchStart = NO;
}

- (void)ccTouchCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // 離したら全て解除
    [self highlightOffAllTiles];
    self.currentSelectTotalPoint = 0;
    isTouchStart = NO;
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


#pragma mark -
#pragma mark TileEventDelegate

- (void)removeTile:(Tile*)tile {
    // 爆発したタイルをリストから除く
    [tileList removeObject:tile];
    
    // 爆発した上のタイルを落とす
    [self downTilesAtRemovedPoistionId:tile.positionId];
}


#pragma mark -

// リストから除いたタイルの上に乗っていたタイルを一段落とす
- (void)downTilesAtRemovedPoistionId:(int)positionId {
    for (Tile* tile in tileList) {
        // 7で割った余りが一緒 = 同じ列
        if ((tile.positionId%7 == positionId%7) && (tile.positionId > positionId)) {
            // タイルを１つ下に落とす
            [tile downTile];
        }
    }
}

// 全てのタイルをせり上げる
- (int)upAllTiles {
    int max = 0;
    for (Tile* tile in tileList) {
        // タイルを１つ下に落とす
        int height = [tile upTile];
        
        // 最大の高さを取得する
        if (max < height) {
            max = height;
        }
    }
    return max;
}

#pragma mark -
#pragma mark Getter/Setter 

// スコアのセッター
- (void)setScore:(int)score {
    _score = score;
    scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
}

// タイマーカウント用のセッター
- (void)setCurrentTimerCount:(int)currentTimerCount {
    _currentTimerCount = currentTimerCount;
    countDownLabel.string = [NSString stringWithFormat:@"0:%.2d", self.currentRestTimeCount];
}

// 「残りX秒」のXの部分を計算して返す
- (int)currentRestTimeCount {
    int limit = 10;
    return (limit - _currentTimerCount);
}

// 現在選択中のサイコロの合計値のセッター
- (void)setCurrentSelectTotalPoint:(int)currentSelectTotalPoint {
    _currentSelectTotalPoint = currentSelectTotalPoint;
    selectCountLabel.string = [NSString stringWithFormat:@"%d/10", _currentSelectTotalPoint];
}

@end
