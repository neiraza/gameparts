//
//  HelloWorldLayer.m
//  gameparts
//
//  Created by 徹 小栗 on 11/12/26.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "GameLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Apple VS. Windows" 
                                               fontName:@"Marker Felt" fontSize:64];
        CGSize size = [[CCDirector sharedDirector] winSize];
        label.position =  ccp( size.width /2 , size.height*3/4 );
        [self addChild: label];
        
        // set up mene items
        CCMenuItem *item1 = [CCMenuItemFont itemFromString: @"PLAY!" 
                                                    target: self selector:@selector(onGameLayer:)];
        
        CCMenu *menu = [CCMenu menuWithItems:item1, nil];
        menu.position = ccp( size.width/2, size.height*1/4);
        
        [menu alignItemsVertically];        
        
        [self addChild:menu];        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

-(void) onGameLayer:(id)item
{
    CCTransitionJumpZoom *trans = [CCTransitionJumpZoom transitionWithDuration:3 
                                                                         scene:[GameLayer scene]];
    
    [[CCDirector sharedDirector] replaceScene:trans];
}
@end
