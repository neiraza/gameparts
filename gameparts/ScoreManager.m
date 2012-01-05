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

-(void)compare
{
    NSLog(@"compare");
    NSInteger difference = projectileGoal_-windowsGoal_;
    if (difference < -50) {
        [self willChangeValueForKey:@"gameover"];
        NSLog(@"compare -50 gameover");
        [self didChangeValueForKey:@"gameover"];
    }
    
}

@end
