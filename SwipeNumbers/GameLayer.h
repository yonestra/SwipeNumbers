//
//  GameLayer.h
//  SwipeNumbers
//
//  Created by 米澤 翔太 on 12/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Tile.h"


// 最初に生成するタイルの個数
#define NUMBER_OF_READY_FOR_TILES 28

// タイルの大きさ
#define TILESIZE   45

// マージン設定
#define MARGIN_LEFT (320-TILESIZE*7)/2

// 効果が発生するダイスの消費個数
#define DICE_COUNT_FLUSH_TRIGGER 10

// ゲームオーバーとなる高さ（列）
#define GAME_OVER_LINE 9

// ブロックを一列追加するのにかける時間（レベル上がるほど数字は小さく）
#define BLOCK_ADD_TIME_DEFAULT 9

// ブロックせり上がりスピードのデフォルト値
#define BLOCK_UP_SPEED_DEFAULT 5

// 選択中のサイコロの値の合計値の状態を表す変数列挙
enum {
    CURRENT_POINT_UNDER_TEN = 0,    // 合計値が10より小さい
    CURRENT_POINT_JUST_TEN,         // 合計値がちょうど10
    CURRENT_POINT_OVER_TEN          // 合計値が10より大きい
};

@interface GameLayer : CCLayer <CCTargetedTouchDelegate, TileEventDelegate> {
    CCArray* tileList;              // 画面に表示されているタイルリスト
    CCAnimate *animate;             // 爆発アニメーション（不要？Tile側に持たせたいところ）
    BOOL isTouchStart;              // タッチが開始したかどうか

    CCLabelTTF *scoreLabel;         // 現在のスコア
    CCLabelTTF *countDownLabel;     // せり上がるまでのカウントダウン
    CCLabelTTF *selectCountLabel;   // 現在選択中のサイコロの合計値が表示されるラベル
    CCLabelTTF *diceSixLabel;       // ゲームオーバーの文字列
    
    CCLabelTTF *diceOneLabel;       // 1のサイコロを消した数
    CCLabelTTF *diceTwoLabel;       // 2のサイコロを消した数
    CCLabelTTF *diceThreeLabel;     // 3のサイコロを消した数
    CCLabelTTF *diceFourLabel;      // 4のサイコロを消した数
    CCLabelTTF *diceFiveLabel;      // 5のサイコロを消した数
    CCLabelTTF *gameOverLabel;       // 6のサイコロを消した数
    
    NSTimer* tm;                    // タイマー
    int blockUpSpeed;               // ブロックのせり上がりスピード
    int blockAddTime;               // ブロックを追加するタイミング
    int blockUpTurn;                // ブロックを何回せりあがらせたか
    float scoreWeight;
}

@property (nonatomic, retain) CCAnimate *animation;         // 爆発アニメーション（Tile側に持たせる）
@property (nonatomic, readonly) BOOL isAddTileLine;         // せり上がりを発動させるかどうか
@property (nonatomic, readonly) int isCurrentPointCheck;    // 選択中のサイコロの合計値の状態をチェックする
@property (nonatomic, assign) int score;                    // 現在のスコア
@property (nonatomic, assign) int countOneDice;             // 1を消した合計数
@property (nonatomic, assign) int countTwoDice;             // 2を消した合計数
@property (nonatomic, assign) int countThreeDice;           // 3を消した合計数
@property (nonatomic, assign) int countFourDice;            // 4を消した合計数
@property (nonatomic, assign) int countFiveDice;            // 5を消した合計数
@property (nonatomic, assign) int countSixDice;             // 6を消した合計数
@property (nonatomic, assign) int currentTimerCount;        // 時間計測用。せり上がり判定などに使う
@property (nonatomic, readonly) int currentRestTimeCount;   // せりあがる迄の時間
@property (nonatomic, assign) int currentSelectTotalPoint;  // 現在のサイコロの値の合計値

+(CCScene *)scene;

@end
