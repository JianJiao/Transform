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

- (void)didLoadFromCCB {
    myType = @"Enemy2";
    self.physicsBody.collisionType = @"enemy";
    self.physicsBody.sensor = YES;
}

@end
