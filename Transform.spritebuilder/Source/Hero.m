//
//  Hero.m
//  Transform
//
//  Created by Jian Jiao on 3/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Hero.h"

@implementation Hero

- (void)startFish
{
    // the animation manager of each node is stored in the 'animationManager' property
    CCAnimationManager* animationManager = self.animationManager;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"fish"];
}

- (void)startHuman{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"human"];
}

- (void)startBird{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"bird"];
}

- (void) startAngel{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"angel"];
}

-(void) bigBird{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"f_big"];
}

@end
