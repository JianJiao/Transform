//
//  WaterBonus.m
//  Transform
//
//  Created by Jian Jiao on 4/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "WaterBonus.h"

@implementation WaterBonus

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"WaterBonus";
    self.physicsBody.sensor = YES;
    self.myType=@"wb";
}

@end
