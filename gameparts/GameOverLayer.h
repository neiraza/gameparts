//
//  GameOverLayer.h
//  gameparts
//
//  Created by 徹 小栗 on 12/01/06.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScoreManager.h"

@interface GameOverLayer : CCLayer {
    NSInteger score_;
}
@property(nonatomic,assign) NSInteger score;

+(CCScene *) scene;

@end
