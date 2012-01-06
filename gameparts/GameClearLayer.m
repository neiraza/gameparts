//
//  GameClearLayer.m
//  gameparts
//
//  Created by 徹 小栗 on 12/01/07.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameClearLayer.h"
#import "GameLayer.h"

@implementation GameClearLayer
+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    GameClearLayer *layer = [GameClearLayer node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
    if ((self=[super init])) {
        CCLabelTTF *gameClearLabel = [CCLabelTTF labelWithString:@"GAME CLEAR" fontName:@"Marker Felt" fontSize:64];
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        [gameClearLabel setPosition:ccp(winSize.width/2, winSize.height*3/4)];
        [self addChild:gameClearLabel];

        CCLabelTTF *congra = [CCLabelTTF labelWithString:@"Congratulations!" fontName:@"Marker Felt" fontSize:32];
        [congra setPosition:ccp(winSize.width/2, winSize.height*3/4-gameClearLabel.contentSize.height)];
        [self addChild:congra];
                
        CCMenuItem *retry=[CCMenuItemFont itemFromString:@"retry" target:self selector:@selector(onGameLayer:)];
        CCMenu *menu=[CCMenu menuWithItems:retry, nil];
        menu.position = ccp(winSize.width/2, winSize.height*3/4-gameClearLabel.contentSize.height-congra.contentSize.height);
        [menu alignItemsVertically];
        [self addChild:menu];
        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}
-(void) onGameLayer:(id)item
{
    CCTransitionJumpZoom *trans = [CCTransitionJumpZoom transitionWithDuration:3 scene:[GameLayer scene]];    
    [[CCDirector sharedDirector] replaceScene:trans];
}

@end
