//
//  Shark.m
//  Transform
//
//  Created by Jian Jiao on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Shark.h"

@implementation Shark

#define ARC4RANDOM_MAX      0x100000000
static const CGFloat range = 275.f;
static const CGFloat start = 288.f;

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"enemy";
    self.physicsBody.sensor = YES;
    
    float delay = (arc4random() % 2000) / 1000.f;
    [self performSelector:@selector(startTeeth) withObject:nil afterDelay:delay];
}

- (void)startTeeth
{
    
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"teeth"];
}

- (void)setupRandomPosition{
    CGFloat random1= ((double)arc4random() / ARC4RANDOM_MAX);
    
    self.position = ccp(self.position.x, random1*range);
}
@end
