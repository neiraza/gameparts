//
//  HelloWorldLayer.m
//  gameparts
//
//  Created by 徹 小栗 on 11/12/26.
//  Copyright __MyCompanyName__ 2011年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize emitter = emitter_;

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
        
        [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
        self.isTouchEnabled = YES;
		
        CCSprite *layer = [CCSprite spriteWithFile:@"toilet.png"];
        [layer setAnchorPoint:ccp(0.5, 0.5)];
        [layer setPosition:ccp(240, 160)];
		[self addChild:layer];
        
        CGSize winSize =[[CCDirector sharedDirector] winSize];
        
        appleSprite_ = [CCSprite spriteWithFile:@"apple.png"];
        [appleSprite_ setAnchorPoint:ccp(0, 0.5)];
        [appleSprite_ setPosition:ccp(0, winSize.height/2)];
        
        [self addChild:appleSprite_];
        
        windowsArr_ = [[NSMutableArray alloc]init];
        projectileArr_ = [[NSMutableArray alloc]init];
        
        [self schedule:@selector(moveWindows:) interval:1.0];
        [self schedule:@selector(update:)];
        
	}
	return self;
}

-(void)moveWindows:(ccTime)dt {
    [self addWindows];
}

-(void)addWindows {
    windowsSprite_ =[CCSprite spriteWithFile:@"windows.png"]; 
    
    windowsSprite_.tag=1;
    [windowsArr_ addObject:windowsSprite_];

    CGSize winSize =[[CCDirector sharedDirector] winSize];
    int minY = windowsSprite_.contentSize.height/2;
    int maxY = winSize.height - windowsSprite_.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY =(arc4random()% rangeY)+ minY;

    windowsSprite_.position = ccp(winSize.width +(windowsSprite_.contentSize.width/2), actualY);
    [self addChild:windowsSprite_];

    int minDuration =2.0;
    int maxDuration =4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration =(arc4random()% rangeDuration)+ minDuration;

    id actionMove =[CCMoveTo actionWithDuration:actualDuration 
                                       position:ccp(-windowsSprite_.contentSize.width/2, actualY)];
    id actionMoveDone =[CCCallFuncN actionWithTarget:self 
                                            selector:@selector(spriteMoveFinished:)];
    [windowsSprite_ runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)spriteMoveFinished:(id)sender {
    CCSprite *sprite =(CCSprite *)sender;
    
    if(sprite.tag==1){
        [windowsArr_ removeObject:sprite];
    }else if(sprite.tag==2){
        [projectileArr_ removeObject:sprite];
    }
    
    [self removeChild:sprite cleanup:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"ccTouchMoved");
    NSLog(@"random=%i",arc4random());
    CGPoint touchPos=[touch locationInView:[touch view]];
    touchPos.x=0;
    CGPoint position=[[CCDirector sharedDirector]convertToGL:touchPos];
    [appleSprite_ setPosition:position];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"ccTouchEnded");
    
    [appleSprite_ stopAllActions];
    
    CGPoint location =[touch locationInView:[touch view]];
    location =[[CCDirector sharedDirector] convertToGL:location];
    
    CGSize winSize =[[CCDirector sharedDirector] winSize];
    CCSprite *projectile =[CCSprite spriteWithFile:@"apple.png"];
    
    projectile.tag=2;
    [projectileArr_ addObject:projectile];
    
    projectile.position = ccp(appleSprite_.position.x, appleSprite_.position.y);
    
    int offX = location.x - projectile.position.x;
    int offY = location.y - projectile.position.y;
    if(offX <=0)return;
    [self addChild:projectile];
    
    int realX = winSize.width +(projectile.contentSize.width/2);
    float ratio =(float) offY /(float) offX;
    int realY =(realX * ratio)+ projectile.position.y;

    CGPoint realDest = ccp(abs(realX)/(arc4random()%5+1), abs(realY)/(arc4random()%5+1));
    CGPoint realDest2 = ccp(abs(realX)/(arc4random()%5+1), abs(realY)/(arc4random()%5+1));
    
    /* Determine the length of how far we're shooting */
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity =480/1; /* 480pixels/1sec */
    float realMoveDuration = length/velocity;
    
    ccBezierConfig bezier1;
    bezier1.controlPoint_1 = realDest;
    bezier1.controlPoint_2 = realDest2;
    bezier1.endPosition = ccp(arc4random()%abs(realX),arc4random()%abs(realY));

    
    id bezierBy = [CCBezierBy actionWithDuration:realMoveDuration bezier:bezier1];
    
    /* Move projectile to actual endpoint */
    [projectile runAction:[CCSequence actions:
                           bezierBy,
                           [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
                           nil]];
}

-(void)update:(ccTime)dt {
    NSMutableArray*projectilesToDelete =[[NSMutableArray alloc] init];
    for(CCSprite *projectile in projectileArr_){
        CGRect projectileRect = CGRectMake(
                                           projectile.position.x -(projectile.contentSize.width/2), 
                                           projectile.position.y -(projectile.contentSize.height/2), 
                                           projectile.contentSize.width, 
                                           projectile.contentSize.height);
        NSMutableArray*windowsToDelete =[[NSMutableArray alloc] init];
        for(CCSprite *windows in windowsArr_){
            CGRect windowsRect = CGRectMake(
                                            windows.position.x -(windows.contentSize.width/2),
                                            windows.position.y -(windows.contentSize.height/2),
                                            windows.contentSize.width,
                                            windows.contentSize.height);
            if(CGRectIntersectsRect(projectileRect, windowsRect)){
                [windowsToDelete addObject:windows];                                
            }                                          
        }
        for(CCSprite *windows in windowsToDelete){
            [windowsArr_ removeObject:windows];
            [self removeChild:windows cleanup:YES];  
        }
        if(windowsToDelete.count > 0){
            [projectilesToDelete addObject:projectile];
        }
        [windowsToDelete release];
    }
    for(CCSprite *projectile in projectilesToDelete){
        [projectileArr_ removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
}

-(void) moveToApple
{
    float appleX = appleSprite_.position.x;
    if (goalX_ < appleX) {
        appleX-=2;
    }else if(goalX_ > appleX){
        appleX+=2;
    }else{
        //なにもしない
    }
    
    NSInteger appleY = appleSprite_.position.y;
    if (goalY_ < appleY) {
        appleY-=2;
    } else if(goalY_ > appleY){
        appleY+=2;
    } else{
        //なにもしない
    }
        
    [appleSprite_ setPosition:ccp(appleX, appleY)];    
    
    id actionUp = [CCJumpBy actionWithDuration:2 position:ccp(0,0) height:50 jumps:4];
    [appleSprite_ runAction: [CCRepeatForever actionWithAction:actionUp]];
    
    
    CGRect appleRect = CGRectMake(appleSprite_.position.x -(appleSprite_.contentSize.width/2), 
                                  appleSprite_.position.y -(appleSprite_.contentSize.height/2), 
                                  appleSprite_.contentSize.width, 
                                  appleSprite_.contentSize.height);
    
    CGRect windowsRect = CGRectMake(windowsSprite_.position.x -(windowsSprite_.contentSize.width/2),
                                    windowsSprite_.position.y -(windowsSprite_.contentSize.height/2), 
                                    windowsSprite_.contentSize.width,
                                    windowsSprite_.contentSize.height);
    
    
    BOOL isTouchHandled = CGRectIntersectsRect(appleRect, windowsRect);
    
    if (isTouchHandled) {
        [self unschedule:@selector(moveToApple)];
        [self unschedule:@selector(moveWindows)];
        [self unschedule:@selector(update)];

        self.emitter = [CCParticleSystemQuad particleWithFile:@"LavaFlow.plist"];
        [self addChild:emitter_];

    }else{

    }

}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
    [windowsArr_ release];
    windowsArr_=nil;
    [projectileArr_ release];
    projectileArr_=nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
