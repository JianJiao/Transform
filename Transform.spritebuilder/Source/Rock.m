//
//  Rock.m
//  Transform
//
//  Created by Jian Jiao on 4/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Rock.h"

@implementation Rock

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"Rock";
}
@end
