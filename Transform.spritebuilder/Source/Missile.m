//
//  Missile.m
//  Transform
//
//  Created by Jian Jiao on 3/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Missile.h"

@implementation Missile

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"missile";
    self.physicsBody.sensor = YES;
}

- (void)startExplosion{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"explosion"];
}

@end
