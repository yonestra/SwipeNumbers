//
//  GameLayer.m
//  SwipeNumbers
//
//  Created by 米澤 翔太 on 12/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "Tile.h"


@implementation GameLayer

+(CCScene *)scene
{
    CCScene *scene = [CCScene node];
    GameLayer *layer = [GameLayer node];
    [scene addChild:layer];
    
    return scene;
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialize
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    
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
    
    // タイル配列を初期化
    tileList = [[CCArray alloc] initWithCapacity:49];
    
    // タイルを配置
    [self arrangeTiles];
}

// 画面いっぱい(49枚)のタイルを作って並べる
- (void)arrangeTiles {
    // タイルを作成
    for (int i=0; i<49; i++) {
//        Tile* tile = [Tile spriteWithTexture:tex
//                                        rect:CGRectMake(tileSize.width*(i%slideTileCount), tileSize.height*(i/slideTileCount),
//                                                        tileSize.width, tileSize.height)];
        Tile* tile = [[Tile alloc] initWithFile:@"Icon-72.png"];
        tile.position = CGPointMake(45*(i%7)+27.5+2.5, 45*(i/7)+27.5+80);
        tile.positionId = i;
        [tileList addObject:tile];
        
        // レイヤーに追加
        [self addChild:tile z:1];
        
    }
}

@end
