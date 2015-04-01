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

- (void)didLoadFromCCB {
    myType = @"Enemy1";
    self.physicsBody.collisionType = @"enemy";
    self.physicsBody.sensor = YES;
}

@end
