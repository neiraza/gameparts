//
//  DispLayer.m
//  gameparts
//
//  Created by 徹 小栗 on 12/01/07.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DispLayer.h"
#import "GameLayer.h"


@implementation DispLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DispLayer *layer = [DispLayer node];
	
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
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Appleを右端に10個放り投げたら勝ち" 
                                               fontName:@"Marker Felt" fontSize:16];
        CGSize size = [[CCDirector sharedDirector] winSize];
        [label setPosition:ccp(size.width/2, size.height*3/4)];
        [self addChild: label];

        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"Windowsが左端に10個放り投げられたら負け" 
                                               fontName:@"Marker Felt" fontSize:16];
        [label2 setPosition:ccp(size.width/2, size.height*3/4-label.contentSize.height)];
        [self addChild: label2];

        CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"Dukeを倒すとWindowsが2個へります" 
                                                fontName:@"Marker Felt" fontSize:16];
        [label3 setPosition:ccp(size.width/2, size.height*3/4-label.contentSize.height-label2.contentSize.height)];
        [self addChild: label3];
        
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
    CCTransitionJumpZoom *trans = [CCTransitionJumpZoom transitionWithDuration:3 scene:[GameLayer scene]];    
    [[CCDirector sharedDirector] replaceScene:trans];
}


@end
