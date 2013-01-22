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
@synthesize countOneDice = _countOneDice;
@synthesize countTwoDice = _countTwoDice;
@synthesize countThreeDice = _countThreeDice;
@synthesize countFourDice = _countFourDice;
@synthesize countFiveDice = _countFiveDice;
@synthesize countSixDice = _countSixDice;
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
        _score = 0;
        _countOneDice = 0;
        _countTwoDice = 0;
        _countThreeDice = 0;
        _countFourDice = 0;
        _countFiveDice = 0;
        _countSixDice = 0;
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
    scoreLabel.position = CGPointMake(50, self.contentSize.height - 20);
    scoreLabel.color = ccc3(255, 255, 255);
    [self addChild:scoreLabel z:1];
    
    // せり上がる迄のカウントダウン
//    countDownLabel = [CCLabelTTF labelWithString:@"0:10" fontName:@"Arial-BoldMT" fontSize:20];
//    countDownLabel.position = CGPointMake(200, self.contentSize.height - 20);
//    countDownLabel.color = ccc3(255, 100, 40);
//    [self addChild:countDownLabel z:1];
    
    // 現在選択中のサイの合計値
//    selectCountLabel = [CCLabelTTF labelWithString:@"0/10" fontName:@"Arial-BoldMT" fontSize:30];
//    selectCountLabel.position = CGPointMake(280, self.contentSize.height - 20);
//    selectCountLabel.color = ccc3(255, 255, 255);
//    [self addChild:selectCountLabel z:1];
    
    // 「ゲームオーバー」
    gameOverLabel = [CCLabelTTF labelWithString:@"ゲームオーバー" fontName:@"Arial-BoldMT" fontSize:40];
    gameOverLabel.position = CGPointMake(160, 240);
    gameOverLabel.color = ccc3(255, 255, 255);
    [self addChild:gameOverLabel];
    gameOverLabel.visible = NO;
    
    float x = 140;
    float y = self.contentSize.height-20;
    
    // これまでに消したサイコロの数パネル
    // 1-画像
    CCSprite* diceOneImage = [[CCSprite alloc] initWithFile:@"dice_1.png"];
    diceOneImage.scale = 0.4;
    diceOneImage.position = CGPointMake(x, y);
    [self addChild:diceOneImage z:1];
    
    // 1-ラベル
    x += 20;
    diceOneLabel = [CCLabelTTF labelWithString:@"×0" fontName:@"Arial-BoldMT" fontSize:15];
    diceOneLabel.position = CGPointMake(x, y);
    diceOneLabel.color = ccc3(255, 255, 255);
    [self addChild:diceOneLabel z:1];
    
    // 2-画像
    x += 25;
    CCSprite* diceTwoImage = [[CCSprite alloc] initWithFile:@"dice_2.png"];
    diceTwoImage.scale = 0.4;
    diceTwoImage.position = CGPointMake(x, y);
    [self addChild:diceTwoImage z:1];
    
    // 2-ラベル
    x += 20;
    diceTwoLabel = [CCLabelTTF labelWithString:@"×0" fontName:@"Arial-BoldMT" fontSize:15];
    diceTwoLabel.position = CGPointMake(x, y);
    diceTwoLabel.color = ccc3(255, 255, 255);
    [self addChild:diceTwoLabel z:1];
    
    // 3-画像
    x += 25;
    CCSprite* diceThreeImage = [[CCSprite alloc] initWithFile:@"dice_3.png"];
    diceThreeImage.scale = 0.4;
    diceThreeImage.position = CGPointMake(x, y);
    [self addChild:diceThreeImage z:1];
    
    // 3-ラベル
    x += 20;
    diceThreeLabel = [CCLabelTTF labelWithString:@"×0" fontName:@"Arial-BoldMT" fontSize:15];
    diceThreeLabel.position = CGPointMake(x, y);
    diceThreeLabel.color = ccc3(255, 255, 255);
    [self addChild:diceThreeLabel z:1];
    
    // 4-画像
    x = 140;
    y -= 20;
    CCSprite* diceFourImage = [[CCSprite alloc] initWithFile:@"dice_4.png"];
    diceFourImage.scale = 0.4;
    diceFourImage.position = CGPointMake(x, y);
    [self addChild:diceFourImage z:1];
    
    // 4-ラベル
    x += 20;
    diceFourLabel = [CCLabelTTF labelWithString:@"×0" fontName:@"Arial-BoldMT" fontSize:15];
    diceFourLabel.position = CGPointMake(x, y);
    diceFourLabel.color = ccc3(255, 255, 255);
    [self addChild:diceFourLabel z:1];
    
    // 5-画像
    x += 25;
    CCSprite* diceFiveImage = [[CCSprite alloc] initWithFile:@"dice_5.png"];
    diceFiveImage.scale = 0.4;
    diceFiveImage.position = CGPointMake(x, y);
    [self addChild:diceFiveImage z:1];
    
    // 5-ラベル
    x += 20;
    diceFiveLabel = [CCLabelTTF labelWithString:@"×0" fontName:@"Arial-BoldMT" fontSize:15];
    diceFiveLabel.position = CGPointMake(x, y);
    diceFiveLabel.color = ccc3(255, 255, 255);
    [self addChild:diceFiveLabel z:1];
    
    // 6-画像
    x += 25;
    CCSprite* diceSixImage = [[CCSprite alloc] initWithFile:@"dice_6.png"];
    diceSixImage.scale = 0.4;
    diceSixImage.position = CGPointMake(x, y);
    [self addChild:diceSixImage z:1];
    
    // 6-ラベル
    x += 20;
    diceSixLabel = [CCLabelTTF labelWithString:@"×0" fontName:@"Arial-BoldMT" fontSize:15];
    diceSixLabel.position = CGPointMake(x, y);
    diceSixLabel.color = ccc3(255, 255, 255);
    [self addChild:diceSixLabel z:1];
    
    
    // 一時停止ボタン
    x += 40;
    y += 10;
    CCSprite* pauseButton = [[CCSprite alloc] initWithFile:@"dice_6.png"];
    pauseButton.scale = 0.8;
    pauseButton.position = CGPointMake(x, y);
    [self addChild:pauseButton z:1];
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
        tile.position = CGPointMake(TILESIZE*(i%7)+TILESIZE/2+MARGIN_LEFT, TILESIZE*(i/7)+TILESIZE/2+15);
        tile.positionId = i;        // 位置番号
        tile.value = randValue;     // サイコロの値
        tile.isTouchabled = YES;    // 最初からタッチ可能に
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
    tm = [NSTimer
          scheduledTimerWithTimeInterval:0.3
          target:self
          selector:@selector(countTimer)
          userInfo:nil
          repeats:YES
          ];
}

// 時間計測用メソッド. 1秒ごとに呼ばれる
- (void)countTimer {
    self.currentTimerCount++;
//    CCLOG(@"timer[%d]", _currentTimerCount);
//    CCLOG(@"tileList[%d]", [tileList count]);
    
    // せり上がりチェック（レベルによってタイミングは異なる）
    if (self.isAddTileLine) {
        // 一列分せり上がらせる
        [self addTileLine];
    }
    
    // 既存のタイルをちょっとせり上がり
    if ([self upAllTiles] > 45*GAME_OVER_LINE) {
        [self showGameOver];
    };
}

// 最下段にタイルを一列追加する
- (void)addTileLine {
    for (int i=0; i<7; i++) {
        // タイルオブジェクトを作る
        int randValue = random()%6 + 1;
        NSString *file = [NSString stringWithFormat:@"dice_%d.png", randValue];
        Tile* tile = [[Tile alloc] initWithFile:file];
        tile.position = CGPointMake(TILESIZE*(i%7)+TILESIZE/2+MARGIN_LEFT, TILESIZE*(i/7)+TILESIZE/2+10);
        tile.positionId = i;        // 位置番号
        tile.height = i/7 * TILESIZE;     // 始めの高さ
        tile.value = randValue;     // サイコロの値
//        tile.isTouchabled = NO;     // はじめはタッチ不能に
        tile.delegate = self;
        [tileList addObject:tile];  // リストに持っておく
        [self addChild:tile];       // 画面に表示する
    }
    
    // タイマーカウンタを初期化
    self.currentTimerCount = 0;
}

// タイマーカウンタを見て、ブロックを追加するタイミングかをチェックする
- (BOOL)isAddTileLine {
    // TODO: レベルの考慮
    if (_currentTimerCount%BLOCK_ADD_TIME == 0) {
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
        if (tile.isTouchabled == NO) {
            continue;
        }
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
            [self countDice:tile.value];
        }
    }
}

// 消したサイコロの種類を数える
- (void)countDice:(NSInteger)diceValue {
    switch (diceValue) {
        case 1:
            self.countOneDice++;
            if (_countOneDice >= DICE_COUNT_FLUSH_TRIGGER) {
                [self oneDiceFlush];
                self.countOneDice -= DICE_COUNT_FLUSH_TRIGGER;
            }
            break;
        case 2:
            self.countTwoDice++;
            if (_countTwoDice >= DICE_COUNT_FLUSH_TRIGGER) {
                [self twoDiceFlush];
                self.countTwoDice -= DICE_COUNT_FLUSH_TRIGGER;
            }
            break;
        case 3:
            self.countThreeDice++;
            if (_countThreeDice >= DICE_COUNT_FLUSH_TRIGGER) {
                [self threeDiceFlush];
                self.countThreeDice -= DICE_COUNT_FLUSH_TRIGGER;
            }
            break;
        case 4:
            self.countFourDice++;
            if (_countFourDice >= DICE_COUNT_FLUSH_TRIGGER) {
                [self fourDiceFlush];
                self.countFourDice -= DICE_COUNT_FLUSH_TRIGGER;
            }
            break;
        case 5:
            self.countFiveDice++;
            if (_countFiveDice >= DICE_COUNT_FLUSH_TRIGGER) {
                [self fiveDiceFlush];
                self.countFiveDice -= DICE_COUNT_FLUSH_TRIGGER;
            }
            break;
        case 6:
            self.countSixDice++;
            if (_countSixDice >= DICE_COUNT_FLUSH_TRIGGER) {
                [self sixDiceFlush];
                self.countSixDice -= DICE_COUNT_FLUSH_TRIGGER;
            }
            break;
        default:
            break;
    }
}

// 「1」が20個揃った時の効果
- (void)oneDiceFlush {
    [self burstAllOneDice];
}

// 「2」が20個揃った時の効果
- (void)twoDiceFlush {
    [self burstFirstRowLine];
}

// 「3」が20個揃った時の効果
- (void)threeDiceFlush {

}

// 「4」が20個揃った時の効果
- (void)fourDiceFlush {
    
}

// 「5」が20個揃った時の効果
- (void)fiveDiceFlush {
    
}

// 「6」が20個揃った時の効果
- (void)sixDiceFlush {
    
}


// ゲームオーバーの処理
- (void)showGameOver {
    for (Tile* tile in tileList) {
        [tile showGameOverTile];
    }
    
    // タイマー停止
    [tm invalidate];
    
    // 「ゲームオーバー」表示
    gameOverLabel.visible = YES;
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
    CCLOG(@"max = %d", max);
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
    int limit = BLOCK_ADD_TIME;
    return (limit - _currentTimerCount);
}

// 現在選択中のサイコロの合計値のセッター
- (void)setCurrentSelectTotalPoint:(int)currentSelectTotalPoint {
    _currentSelectTotalPoint = currentSelectTotalPoint;
    selectCountLabel.string = [NSString stringWithFormat:@"%d/10", _currentSelectTotalPoint];
}

// 1 のダイスが消された
- (void)setCountOneDice:(int)countOneDice {
    _countOneDice = countOneDice;
    diceOneLabel.string = [NSString stringWithFormat:@"×%d", _countOneDice];
}

// 2 のダイスが消された
- (void)setCountTwoDice:(int)countTwoDice {
    _countTwoDice = countTwoDice;
    diceTwoLabel.string = [NSString stringWithFormat:@"×%d", _countTwoDice];
}

// 3 のダイスが消された
- (void)setCountThreeDice:(int)countThreeDice {
    _countThreeDice = countThreeDice;
    diceThreeLabel.string = [NSString stringWithFormat:@"×%d", _countThreeDice];
}

// 4 のダイスが消された
- (void)setCountFourDice:(int)countFourDice {
    _countFourDice = countFourDice;
    diceFourLabel.string = [NSString stringWithFormat:@"×%d", _countFourDice];
}

// 5 のダイスが消された
- (void)setCountFiveDice:(int)countFiveDice {
    _countFiveDice = countFiveDice;
    diceFiveLabel.string = [NSString stringWithFormat:@"%d", _countFiveDice];
}

// 6 のダイスが消された
- (void)setCountSixDice:(int)countSixDice {
    _countSixDice = countSixDice;
    diceSixLabel.string = [NSString stringWithFormat:@"×%d", _countSixDice];
}


/////// Special /////////

// 「1」のダイスを全消し
- (void)burstAllOneDice {
    for (Tile* tile in tileList) {
        if (tile.value == 1 && [tile isHighlighted] == NO) {
            [tile burstWithAnimation];
        }
    }
}

// 左端の一列を消す
- (void)burstFirstRowLine {
    for (Tile* tile in tileList) {
        if (tile.positionId%7 == 0 && [tile isHighlighted] == NO) {
            [tile burstWithAnimation];
        }
    }
}


@end
