//
//  GameEnd.m
//  Transform
//
//  Created by Jian Jiao on 4/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameEnd.h"

@implementation GameEnd{
    CCLabelTTF *_messageLabel;
    CCLabelTTF *_scoreLabel;
}

- (void)newGame {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector]replaceScene:mainScene];
}

- (void)menu{
    CCScene *controlScene = [CCBReader loadAsScene:@"ControlScene"];
    [[CCDirector sharedDirector]replaceScene:controlScene];
}

- (void)setMessage:(NSString *)message score:(NSInteger)score {
    _messageLabel.string = message;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", score];
}
@end
