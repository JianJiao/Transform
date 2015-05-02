//
//  Heal.m
//  Transform
//
//  Created by Jian Jiao on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Heal.h"

@implementation Heal
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"Heal";
    self.physicsBody.sensor = YES;

}

@end
