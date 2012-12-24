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
#define NUMBER_OF_READY_FOR_TILES 49

// タイルの大きさ
#define TILESIZE   45

// マージン設定
#define MARGIN_LEFT (320-TILESIZE*7)/2

// 選択中のサイコロの値の合計値の状態を表す変数列挙
enum {
    CURRENT_POINT_UNDER_TEN = 0,    // 合計値が10より小さい
    CURRENT_POINT_JUST_TEN,         // 合計値がちょうど10
    CURRENT_POINT_OVER_TEN          // 合計値が10より大きい
};

@interface GameLayer : CCLayer <CCTargetedTouchDelegate, TileEventDelegate> {
    CCArray* tileList;              // 画面に表示されているタイルリスト
    CCAnimate *animate;             // 爆発アニメーション（不要？Tile側に持たせたいところ）
    int currentTimerCount;          // 時間計測用。せり上がり判定などに使う
    int currentSelectTotalPoint;    // 現在のサイコロの値の合計値
}

@property (nonatomic, retain) CCAnimate *animation;         // 爆発アニメーション（Tile側に持たせる）
@property (nonatomic, readonly) BOOL isAddTileLine;         // せり上がりを発動させるかどうか
@property (nonatomic, readonly) int isCurrentPointCheck;    // 選択中のサイコロの合計値の状態をチェックする

+(CCScene *)scene;

@end
