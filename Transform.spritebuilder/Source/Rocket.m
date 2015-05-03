//
//  Rocket.m
//  Transform
//
//  Created by Jian Jiao on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Rocket.h"

@implementation Rocket
#define ARC4RANDOM_MAX      0x100000000
static const CGFloat range = 275.f;
static const CGFloat start = 288.f;

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"rock";
    self.physicsBody.sensor = YES;
}

- (void)setupRandomPosition{
    CGFloat random1= ((double)arc4random() / ARC4RANDOM_MAX);
    
    self.position = ccp(self.position.x, range + random1*range);
}

-(void) anotherMethod{
    NSLog(@"this method gets called");
}
@end
