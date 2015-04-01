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
static const CGFloat range = 0.45f;
static const CGFloat start = 0.5f;


- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"levela";
    self.physicsBody.sensor = YES;
}

- (void)setupRandomPositionWith: (NSString*) enemyType {
    CGFloat random= ((double)arc4random() / ARC4RANDOM_MAX);
    if([enemyType isEqualToString:@"Enemy2"]){
        self.position = ccp(self.position.x, random*range);
    }else if ([enemyType isEqualToString:@"Enemy1"]){
        self.position = ccp(self.position.x, start + random*range);
    }
}@end
