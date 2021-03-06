//
//  GameOverLayer.m
//  gameparts
//
//  Created by 徹 小栗 on 12/01/06.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "GameLayer.h"

@implementation GameOverLayer
@synthesize score=score_;

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [GameOverLayer node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
    if ((self=[super init])) {
        CCLabelTTF *gameOverLabal = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"Marker Felt" fontSize:64];
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        [gameOverLabal setPosition:ccp(winSize.width/2, winSize.height*3/4)];
        [self addChild:gameOverLabal];

        CCMenuItem *retry=[CCMenuItemFont itemFromString:@"retry" target:self selector:@selector(onGameLayer:)];
        CCMenu *menu=[CCMenu menuWithItems:retry, nil];
        menu.position = ccp(winSize.width/2, winSize.height*3/4-gameOverLabal.contentSize.height);
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
