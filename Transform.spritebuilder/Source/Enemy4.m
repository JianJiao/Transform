//
//  Enemy4.m
//  Transform
//
//  Created by Jian Jiao on 5/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Enemy4.h"

@implementation Enemy4
#define ARC4RANDOM_MAX      0x100000000
static const CGFloat range = 275.f;
static const CGFloat start = 288.f;


- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"enemy";
    self.physicsBody.sensor = YES;
}

- (void)setupRandomPosition{
    CGFloat random1= ((double)arc4random() / ARC4RANDOM_MAX);
    
    self.position = ccp(self.position.x, range+ random1*range);
}
@end
