//
//  HelloWorldLayer.h
//  gameparts
//
//  Created by 徹 小栗 on 11/12/26.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer<CCTargetedTouchDelegate>
{
    CCSprite *appleSprite_;
    CCSprite *windowsSprite_;
    float goalX_;
    float goalY_;
    CCParticleSystem *emitter_;
    NSMutableArray *windowsArr_;
    NSMutableArray *projectileArr_;
}
@property(readwrite,retain) CCParticleSystem *emitter;

-(void)addWindows;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
