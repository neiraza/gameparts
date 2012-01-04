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

-(void)addProjectileGoal
{
    NSLog(@"addProjectileGoal=%d",projectileGoal_);
    [self willChangeValueForKey:@"projectile"];
    projectileGoal_+=1;
    [self didChangeValueForKey:@"projectile"];    
}

-(void)addWindowsGoal
{
    NSLog(@"addWindowsGoal=%d",windowsGoal_);
    [self willChangeValueForKey:@"windows"];
    windowsGoal_+=1;
    [self didChangeValueForKey:@"windows"];    
}

@end
