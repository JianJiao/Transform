//
//  Enemy1.h
//  Transform
//
//  Created by Jian Jiao on 3/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Enemy : CCSprite

@property NSString *myType;
@property bool removed;
- (void)setupRandomPositionWith: (NSString*) enemyType;


@end
