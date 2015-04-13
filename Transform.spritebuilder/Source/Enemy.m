//
//  Enemy1.m
//  Transform
//
//  Created by Jian Jiao on 3/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

#define ARC4RANDOM_MAX      0x100000000

// visibility on a 3,5-inch iPhone ends a 88 points and we want some meat
static const CGFloat range = 275.f;
static const CGFloat start = 288.f;



- (void)setupRandomPositionWith: (NSString*) enemyType {
    CGFloat random1= ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat random2= ((double)arc4random()/ ARC4RANDOM_MAX);
    if([enemyType isEqualToString:@"Enemy2"]){
        self.position = ccp(self.position.x, start + random2
                            *range);
    }else if ([enemyType isEqualToString:@"Enemy1"]){
        self.position = ccp(self.position.x,10+ random1*range);
    }
}@end
