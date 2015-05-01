//
//  Explosion.m
//  Transform
//
//  Created by Jian Jiao on 5/1/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"explosion";
    self.physicsBody.sensor = YES;
}

@end
