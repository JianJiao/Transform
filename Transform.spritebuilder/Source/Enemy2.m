//
//  Enemy2.m
//  Transform
//
//  Created by Jian Jiao on 3/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Enemy2.h"

@implementation Enemy2{
    NSString* myType;
}


#define ARC4RANDOM_MAX      0x100000000
static const CGFloat range = 280.f;
static const CGFloat start = 288.f;

- (void)didLoadFromCCB {
    self.myType = @"Enemy2";
    self.physicsBody.collisionType = @"enemy";
    self.physicsBody.sensor = YES;
}

- (void)setupRandomPosition{
    CGFloat random1= ((double)arc4random() / ARC4RANDOM_MAX);
    
    self.position = ccp(self.position.x, range + random1*range);
}

@end
