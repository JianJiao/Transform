//
//  WrapperBird.m
//  Transform
//
//  Created by Jian Jiao on 4/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "WrapperBird.h"

@implementation WrapperBird


- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"wrapperbird";
    self.physicsBody.sensor = YES;
}
@end
