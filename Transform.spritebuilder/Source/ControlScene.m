//
//  ControlScene.m
//  Transform
//
//  Created by Jian Jiao on 4/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ControlScene.h"

@implementation ControlScene

- (void)play {
    NSLog(@"called here");
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
