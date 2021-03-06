//
//  Tile.h
//  SwipeNumbers
//
//  Created by 平松 亮介 on 2012/12/23.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define TILE_MOVE_UP_DELTA  5   // タイルの一回の移動量(px)

@protocol TileEventDelegate;

/**
 *  画面に表示されるタイルのオブジェクト
 *
 */
@interface Tile : CCSprite  {
    CCSprite *highlightedFrame;     // ハイライト時に表示するスプライト
    CCSprite *gameOverFrame;        // ゲームオーバ時に表示するスプライト
    CCAnimate *animate;             // 爆発時のアニメーション
    id actBurst;                    // 爆発時に表示するアニメーション群
    BOOL isBursting;                // 爆発中かどうか
    int height;                     // 現在のタイルの高さ
}

@property (nonatomic, assign) int positionId;           // タイルの場所を表す値
@property (nonatomic, assign) int value;                // タイルのサイコロ値（1~6）
@property (nonatomic, readonly) BOOL isHighlighted;     // タイルがハイライト状態かどうか

@property (nonatomic, assign) id<TileEventDelegate> delegate; 


- (BOOL)containsTouchLocation:(UITouch *)touch;         // touchの対象タイルかどうかを返す
- (void)setHighlighted:(BOOL)highlighted;               // タイルの選択状態を切り替える
- (void)changeTileValue:(int)newValue;                  // タイルの数字を更新する
- (void)burstWithAnimation;                             // タイルを爆発させる
- (int)upTile;                                          // タイルを１つ上にあげる
- (void)downTile;                                       // タイルを１つ下に落とす
- (void)showGameOverTile;                               // タイルをゲームオーバー表示する

@end


/**
 * タイルに関するイベントが発生した際のイベント通知用デリゲート
 *
 */
@protocol TileEventDelegate <NSObject>

- (void)removeTile:(Tile*)tile;
- (void)plusScore:(int)value;

@end
