//
//  GameLayer.m
//  gameparts
//
//  Created by 徹 小栗 on 11/12/31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "GameOverLayer.h"

@implementation GameLayer
@synthesize emitter = emitter_;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}

-(void) onGameOverLayer:(id)item
{
    [self unschedule:@selector(update)];
    [self unschedule:@selector(moveToPoint)];
    
    CCScene *nextScene = [GameOverLayer scene];
    GameOverLayer *nextSceneLayer = [nextScene.children objectAtIndex:0];
    NSLog(@"Score=%d",scoreManager_.score);
    nextSceneLayer.score = scoreManager_.score;
    NSLog(@"Score=%d",nextSceneLayer.score);

    CCTransitionJumpZoom *trans = [CCTransitionJumpZoom transitionWithDuration:3 scene:nextScene];    
    [[CCDirector sharedDirector] replaceScene:trans];    
}

-(id) init
{
	if( (self=[super init])) {
        scoreManager_ = [[ScoreManager alloc]init];
        [scoreManager_ addObserver:self forKeyPath:@"score" options:0 context:nil];
        [scoreManager_ addObserver:self forKeyPath:@"projectile" options:0 context:nil];
        [scoreManager_ addObserver:self forKeyPath:@"windows" options:0 context:nil];
        [scoreManager_ addObserver:self forKeyPath:@"gameover" options:0 context:nil];

        winSize_ =[[CCDirector sharedDirector] winSize];

        [[CCTouchDispatcher sharedDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
        self.isTouchEnabled = YES;
		
        CCSprite *layer = [CCSprite spriteWithFile:@"toilet.png"];
        [layer setAnchorPoint:ccp(0.5, 0.5)];
        [layer setPosition:ccp(240, 160)];
		[self addChild:layer];
        
        scoreLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score：%d",scoreManager_.score] fontName:@"TimesNewRomanPS-BoldItalicMT" fontSize:22];
        [scoreLabel_ setAnchorPoint:ccp(0, 1)];
        [scoreLabel_ setPosition:ccp(0, winSize_.height)];
        [self addChild:scoreLabel_];

        projectitleLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Apple：%d",scoreManager_.windowsGoal] fontName:@"TimesNewRomanPS-BoldItalicMT" fontSize:22];
        [projectitleLabel_ setAnchorPoint:ccp(1, 1)];
        [projectitleLabel_ setPosition:ccp(winSize_.width, winSize_.height)];
        [self addChild:projectitleLabel_];
        
        windowsLabel_ = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Windos：%d",scoreManager_.windowsGoal] fontName:@"TimesNewRomanPS-BoldItalicMT" fontSize:22];
        [windowsLabel_ setAnchorPoint:ccp(1, 1)];
        [windowsLabel_ setPosition:ccp(winSize_.width, winSize_.height-projectitleLabel_.contentSize.height)];
        [self addChild:windowsLabel_];

        appleSprite_ = [CCSprite spriteWithFile:@"apple.png"];
        [appleSprite_ setPosition:ccp(appleSprite_.contentSize.width/2, winSize_.height/2)];
        
        [self addChild:appleSprite_];
                
        windowsArr_ = [[NSMutableArray alloc]init];
        projectileArr_ = [[NSMutableArray alloc]init];
        
        [self schedule:@selector(moveWindows:) interval:0.5];
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
    
    int minY = windowsSprite_.contentSize.height/2;
    int maxY = winSize_.height - windowsSprite_.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY =(arc4random()% rangeY)+ minY;
    
    windowsSprite_.position = ccp(winSize_.width +(windowsSprite_.contentSize.width/2), actualY);
    [self addChild:windowsSprite_];
    
    int minDuration =1.0;
    int maxDuration =4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration =(arc4random()% rangeDuration)+ minDuration;
    
    id actionMove =[CCMoveTo actionWithDuration:actualDuration
                                       position:ccp(-windowsSprite_.contentSize.width/2, actualY)];
    id actionMoveDone =[CCCallFuncN actionWithTarget:self 
                                            selector:@selector(spriteMoveFinished:)];
    [windowsSprite_ runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if ([keyPath isEqualToString:@"score"] == YES) {
        [scoreLabel_ setString:[NSString stringWithFormat:@"Score：%d",scoreManager_.score]];
    }
    if ([keyPath isEqualToString:@"projectile"] == YES) {
        [projectitleLabel_ setString:[NSString stringWithFormat:@"Apple：%d",scoreManager_.projectileGoal]];
    }
    if ([keyPath isEqualToString:@"windows"] == YES) {
        [windowsLabel_ setString:[NSString stringWithFormat:@"Windows：%d",scoreManager_.windowsGoal]];
    }
    if ([keyPath isEqualToString:@"gameover"] == YES) {
        NSLog(@"observeValueForKeyPath GameOver");
        [self onGameOverLayer:self];
    }

}

-(void)spriteMoveFinished:(id)sender
{
    CCSprite *sprite =(CCSprite *)sender;
    
    if(sprite.tag==1){
        if (sprite.position.x >= 0 - sprite.contentSize.width/2) {
            if (sprite.position.y > 0 && sprite.position.y < winSize_.height) {
                [scoreManager_ addWindowsGoal];
            }
        }
        [windowsArr_ removeObject:sprite];
    }else if(sprite.tag==2){
        if (sprite.position.x >= winSize_.width + sprite.contentSize.width/2) {
            if (sprite.position.y > 0 && sprite.position.y < winSize_.height) {
                [scoreManager_ addProjectileGoal];
            }
        }
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
    CGPoint touchPos=[touch locationInView:[touch view]];
    touchPos.x=appleSprite_.contentSize.width/2;
    CGPoint position=[[CCDirector sharedDirector]convertToGL:touchPos];
    [appleSprite_ setPosition:position];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [appleSprite_ stopAllActions];
    
    CGPoint location =[touch locationInView:[touch view]];
    location =[[CCDirector sharedDirector] convertToGL:location];
    
    CCSprite *projectile =[CCSprite spriteWithFile:@"apple.png"];
    
    projectile.tag=2;
    [projectileArr_ addObject:projectile];
    
    projectile.position = ccp(appleSprite_.position.x, appleSprite_.position.y);
    
    if (location.x < appleSprite_.position.x) {
        return;
    }
    
    int realX = (winSize_.width +(projectile.contentSize.width/2))/(arc4random()%2+1);
    int realY = winSize_.height/(arc4random()%4+1);
    CGPoint realDest;
    CGPoint realDest2;
    CGPoint endPosition;
    
    if (location.y > winSize_.height/2) {
        realDest = ccp(realX, realY);
        realDest2 = ccp(realX, -(realY));
        endPosition = ccp(realX, realY);
    }else{
        realDest = ccp(realX, -(realY));
        realDest2 = ccp(realX, realY);
        endPosition = ccp(realX, -(realY));
    }
    
    [self addChild:projectile];
        
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity =480/(arc4random()%3+1);
    float realMoveDuration = length/velocity;
    
    ccBezierConfig bezier1;
    bezier1.controlPoint_1 = realDest;
    bezier1.controlPoint_2 = realDest2;
    bezier1.endPosition = endPosition;
    
    id bezierBy = [CCBezierBy actionWithDuration:realMoveDuration bezier:bezier1];
    
    [projectile runAction:[CCSequence actions:
                           bezierBy,
                           [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
                           nil]];
}

-(void)update:(ccTime)dt
{
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
            [scoreManager_ addScore];
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
    [scoreManager_ removeObserver:self forKeyPath:@"score"];
    [scoreManager_ removeObserver:self forKeyPath:@"projectile"];
    [scoreManager_ removeObserver:self forKeyPath:@"windows"];
    [scoreManager_ removeObserver:self forKeyPath:@"gameover"];
    [scoreManager_ release];
    [windowsArr_ release];
    windowsArr_=nil;
    [projectileArr_ release];
    projectileArr_=nil;
    
	[super dealloc];
}

@end
