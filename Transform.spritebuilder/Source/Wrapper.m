//
//  Wrapper.m
//  Transform
//
//  Created by Jian Jiao on 4/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Wrapper.h"

@implementation Wrapper

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"wrapper";
    self.physicsBody.sensor = YES;
}

@end
