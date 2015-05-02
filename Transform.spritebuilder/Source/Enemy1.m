//
//  Enemy1.m
//  Transform
//
//  Created by Jian Jiao on 3/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Enemy1.h"

@implementation Enemy1{
    NSString* myType;
}

#define ARC4RANDOM_MAX      0x100000000
static const CGFloat range = 275.f;
static const CGFloat start = 288.f;

- (void)didLoadFromCCB {
    self.myType = @"Enemy1";
    self.physicsBody.collisionType = @"enemy";
    self.physicsBody.sensor = YES;

    float delay = (arc4random() % 2000) / 1000.f;
    [self performSelector:@selector(startTeeth) withObject:nil afterDelay:delay];
}

- (void)startTeeth
{

    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"Teeth"];
}

- (void)setupRandomPosition{
    CGFloat random1= ((double)arc4random() / ARC4RANDOM_MAX);
    
    self.position = ccp(self.position.x, range + random1*range);
}

@end
