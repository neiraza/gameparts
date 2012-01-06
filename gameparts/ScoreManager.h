//
//  ScoreManager.h
//  gameparts
//
//  Created by 徹 小栗 on 12/01/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreManager : NSObject
{
    NSInteger score_;
    NSInteger projectileGoal_;
    NSInteger windowsGoal_;

}
@property(nonatomic,assign) NSInteger score;
@property(nonatomic,assign) NSInteger projectileGoal;
@property(nonatomic,assign) NSInteger windowsGoal;

-(void)addScore;
-(void)addScore30;
-(void)addScore100;
-(void)addProjectileGoal;
-(void)addWindowsGoal;
-(void)deleteWindowsScore10;
-(void)compare;


@end
