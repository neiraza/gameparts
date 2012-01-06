//
//  ScoreManager.m
//  gameparts
//
//  Created by 徹 小栗 on 12/01/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScoreManager.h"

@implementation ScoreManager
@synthesize score=score_;
@synthesize projectileGoal=projectileGoal_;
@synthesize windowsGoal=windowsGoal_;

-(id)init
{
    if ((self=[super init])) {
        score_=0;
        projectileGoal_=0;
        windowsGoal_=0;
    } 
    return self;
}

-(void)addScore
{
    [self willChangeValueForKey:@"score"];
    score_+=10;
    [self didChangeValueForKey:@"score"];
}

-(void)addScore30
{
    [self willChangeValueForKey:@"score30"];
    score_+=30;
    [self didChangeValueForKey:@"score30"];
}

-(void)addScore100
{
    [self willChangeValueForKey:@"score100"];
    score_+=100;
    [self didChangeValueForKey:@"score100"];
}

-(void)addProjectileGoal
{
    [self willChangeValueForKey:@"projectile"];
    projectileGoal_+=1;
    [self compare];
    [self didChangeValueForKey:@"projectile"];    
}

-(void)addWindowsGoal
{
    [self willChangeValueForKey:@"windows"];
    windowsGoal_+=1;
    [self compare];
    [self didChangeValueForKey:@"windows"];    
}

-(void)deleteWindowsScore10
{
    [self willChangeValueForKey:@"windowsDelete"];
    if (windowsGoal_>0) {
        windowsGoal_-=2;
    }else{
        projectileGoal_+=1;
    }
    [self compare];
    [self didChangeValueForKey:@"windowsDelete"];    
    
}

-(void)compare
{
    NSInteger difference = projectileGoal_-windowsGoal_;
    if (difference < -10) {
        [self willChangeValueForKey:@"gameover"];
        [self didChangeValueForKey:@"gameover"];
    }
    if (difference > 10) {
        [self willChangeValueForKey:@"gameclear"];
        [self didChangeValueForKey:@"gameclear"];
    }
//    if (difference > 10) {
//        [self willChangeValueForKey:@"droidStart"];
//        [self didChangeValueForKey:@"droidStart"];
//    }
//    if (difference < 10) {
//        [self willChangeValueForKey:@"droidEnd"];
//        [self didChangeValueForKey:@"droidSEnd"];
//    }
    
}

@end
