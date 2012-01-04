//
//  GameLayer.h
//  gameparts
//
//  Created by 徹 小栗 on 11/12/31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScoreManager.h"

@interface GameLayer : CCLayer 
{
    CCSprite *appleSprite_;
    CCSprite *windowsSprite_;
    float goalX_;
    float goalY_;
    CCParticleSystem *emitter_;
    NSMutableArray *windowsArr_;
    NSMutableArray *projectileArr_;
    CCLabelTTF *scoreLabel_;
    ScoreManager *scoreManager_;
    CCLabelTTF *projectitleLabel_;
    CCLabelTTF *windowsLabel_;
    CGSize winSize_;
}
@property(readwrite,retain) CCParticleSystem *emitter;
-(void)addWindows;

+(CCScene *) scene;

@end
