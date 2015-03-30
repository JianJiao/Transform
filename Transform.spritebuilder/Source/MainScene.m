//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Benjamin Encz on 10/10/13.
//  Copyright (c) 2014 MakeGamesWithUs inc. Free to use for all purposes.
//

#import "MainScene.h"
#import "Obstacle.h"
#import "Hero.h"
#import "missile.h"

static const CGFloat firstObstaclePosition = 280.f;
static const CGFloat distanceBetweenObstacles = 160.f;

typedef NS_ENUM (NSInteger, DrawingOrder) {
  DrawingOrderPipes,
  DrawingOrderGround,
  DrawingOrdeHero
};

@implementation MainScene {
    Hero *_hero;
    Missile *_missile;
    
    CCPhysicsNode *_physicsNode;

    CCNode *_ground1, *_ground2, *_ground3, *_ground4,*_ground5, *_ground6;

    NSArray *_grounds0, *_grounds1, *_grounds2;

    NSTimeInterval _sinceTouch;
    NSTimeInterval _sinceHit;
    

    NSMutableArray *_obstacles;

    CCButton *_restartButton;

    BOOL _gameOver;

    CGFloat _scrollSpeed;

    NSInteger _points;
    CCLabelTTF *_scoreLabel;
    
    NSString *charPosition;
    
    NSString *atRoof;
    NSString *atGround;
    NSString *atUpper;
    NSString *atLower;
    
    CGPoint downGravity, upGravity;
    
    float yVelocity;
}



- (void)didLoadFromCCB {
  _scrollSpeed = 80.f;
  self.userInteractionEnabled = YES;

    _grounds0 = @[_ground1, _ground2];
    _grounds1 = @[_ground3, _ground4];
    _grounds2 = @[_ground5, _ground6];

    // lower limit
    for (CCNode *ground in _grounds0) {
        // set collision type
        ground.physicsBody.collisionType = @"level";
        ground.zOrder = DrawingOrderGround;
    }
    // upper limit
    for(CCNode *ground in _grounds1){
        ground.physicsBody.collisionType = @"roof";
        ground.zOrder = DrawingOrderGround;
    }
    // middle sensor
    for(CCNode *ground in _grounds2){
        ground.physicsBody.collisionType = @"middle";
        ground.physicsBody.sensor = TRUE;
        ground.zOrder = DrawingOrderGround;
    }
    
    atRoof = @"roof";
    atGround = @"ground";
    atUpper = @"upper";
    atLower = @"lower";
    
    downGravity = ccp(0.0, -300.0);
    upGravity = ccp(0.0, 300);



    // set this class as delegate
    _physicsNode.collisionDelegate = self;
    // set collision type
    _hero.physicsBody.collisionType = @"hero";
    _hero.zOrder = DrawingOrdeHero;

  _obstacles = [NSMutableArray array];
//  [self spawnNewObstacle];
//  [self spawnNewObstacle];
//  [self spawnNewObstacle];
}



#pragma mark - Touch Handling

- (void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event {
  if (!_gameOver) {
      CGPoint touchLocation = [touch locationInNode:self];
      if(touchLocation.x<=160.f){
          // on the left, jump
          if ([charPosition isEqualToString: atGround] && _sinceHit>1.0f) {
              // if on the ground, jump and reverse gravity
              // reset ground collision type to allow event handling
              // set char position to lower
              // become a fish
              [_hero.physicsBody applyImpulse:ccp(0, 50.f)];
              _physicsNode.gravity = upGravity;
              for (CCNode *ground in _grounds0) {
                  // set collision type
                  ground.physicsBody.collisionType = @"level";
              }
              charPosition = atLower;
              [_hero performSelector:@selector(startFish) withObject:nil afterDelay:0.f];
          }else if([charPosition isEqualToString:atLower]){
              // if at lower space, apply downward force
              [_hero.physicsBody applyImpulse:ccp(0, -300.f)];
          }else if([charPosition isEqualToString:atUpper]){
              // if at upper space, apply upward force
              [_hero.physicsBody applyImpulse:ccp(0, 300.f)];
          }else if([charPosition isEqualToString:atRoof] && _sinceHit>1.0f){
              // if at roof, jump down and reverse gravity
              // reset roof collision type to allow event handling
              // set char position to upper
              // become a bird
              [_hero.physicsBody applyImpulse:ccp(0, -50.f)];
              _physicsNode.gravity = downGravity;
              for (CCNode *ground in _grounds1) {
                  // set collision type
                  ground.physicsBody.collisionType = @"roof";
              }
              charPosition = atUpper;
              [_hero performSelector:@selector(startBird) withObject:nil afterDelay:0.f];
          }
      }else{
          // on the right, shoot
        [self launchMissileWith:touchLocation];
      }
//    [_hero.physicsBody applyImpulse:ccp(0, -400.f)];
    //[_hero.physicsBody applyAngularImpulse:10000.f];
    _sinceTouch = 0.f;
  }
}

- (void) launchMissileWith: (CGPoint) touchPosition{
    CCNode* missile = [CCBReader load:@"Missile"];
    missile.position = ccpAdd(_hero.position, ccp(30,0));
    [_physicsNode addChild:missile];
    CGPoint launchDirection = [self getDirectionWith:touchPosition];
    //CGPoint launchDirection = ccp(2, 0);
    CGPoint force = ccpMult(launchDirection, 50);
    [missile.physicsBody applyForce:force];
}

- (CGPoint) getDirectionWith: (CGPoint) touchPosition{
    // get the screen position of the hero
    CGPoint heroPosition = [_physicsNode convertToWorldSpace:_hero.position];
    CGPoint launchDirection = ccp(touchPosition.x-heroPosition.x, touchPosition.y-heroPosition.y);
    return launchDirection;
    

}

#pragma mark - CCPhysicsCollisionDelegate

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(CCNode *)level {
    _physicsNode.gravity= downGravity;
    
    // start the timer
    _sinceHit = 0.f;
    // set yvelocity to 0
    _hero.physicsBody.velocity = ccp(0, 0);

    
    
    // set char position to ground
    charPosition = atGround;
    
    // reset ground collision type
    for (CCNode *ground in _grounds0) {
        ground.physicsBody.collisionType = @"noMatch";
    }
    
    // become a handsome young man again
    [_hero performSelector:@selector(startHuman) withObject:nil afterDelay:0.f];

  return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero roof:(CCNode *)roof {
    
    
    
    _physicsNode.gravity= upGravity;
    
    // set the timer
    _sinceHit = 0.f;
    // set y velocity to 0
    _hero.physicsBody.velocity = ccp(0, yVelocity);

    
    // set char position to roof
    charPosition = atRoof;
    
    
    for (CCNode *ground in _grounds1) {
        // set collision type
        ground.physicsBody.collisionType = @"noMatch";
    }
    
    //become a cute angel
    [_hero performSelector:@selector(startAngel) withObject:nil afterDelay:0.f];
    
    return YES;
}


- (BOOL)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero middle:(CCNode *)middle{
    //NSLog(@"ok, detected");
    //NSLog(@"%f",hero.position.y);
    if(hero.position.y > 284){
        // at upper space
        // turn gravity downward, set char position at upper
        // turn into a bird
        _physicsNode.gravity = downGravity;
        charPosition = atUpper;
        [_hero performSelector:@selector(startBird) withObject:nil afterDelay:0.f];


    }else{
        // at lower space
        // turn gravity upward, set char position at lower
        // turn into a fish
        _physicsNode.gravity = upGravity;
        charPosition = atLower;
        [_hero performSelector:@selector(startFish) withObject:nil afterDelay:0.f];
        

        
    }
    
    
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero goal:(CCNode *)goal {
  [goal removeFromParent];

  _points++;
  _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)_points];

  return YES;
}

#pragma mark - Game Actions

- (void)gameOver {
  if (!_gameOver) {
    _scrollSpeed = 0.f;
    _gameOver = YES;
    _restartButton.visible = YES;

    _hero.rotation = 90.f;
    _hero.physicsBody.allowsRotation = NO;
    [_hero stopAllActions];

    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.2f position:ccp(-2, 2)];
    CCActionInterval *reverseMovement = [moveBy reverse];
    CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
    CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];

    [self runAction:bounce];
  }
}


- (void)restart {
  CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
  [[CCDirector sharedDirector]replaceScene:scene];
}

#pragma mark - Obstacle Spawning

- (void)spawnNewObstacle {
  CCNode *previousObstacle = [_obstacles lastObject];
  CGFloat previousObstacleXPosition = previousObstacle.position.x;

  if (!previousObstacle) {
    // this is the first obstacle
    previousObstacleXPosition = firstObstaclePosition;
  }

  Obstacle *obstacle = (Obstacle *)[CCBReader load:@"Obstacle"];
  obstacle.position = ccp(previousObstacleXPosition + distanceBetweenObstacles, 0);
  [obstacle setupRandomPosition];
  obstacle.zOrder = DrawingOrderPipes;
  [_physicsNode addChild:obstacle];
  [_obstacles addObject:obstacle];
}

#pragma mark - Update

- (void)update:(CCTime)delta {
  // clamp velocity
    if([charPosition isEqualToString:atUpper] || [charPosition isEqualToString:atRoof]){
        yVelocity = clampf(_hero.physicsBody.velocity.y, -1*MAXFLOAT, 100.f);
    }else{
        yVelocity = clampf(_hero.physicsBody.velocity.y, -100.f, MAXFLOAT);
    }
    
  _hero.physicsBody.velocity = ccp(0, yVelocity);
  _hero.position = ccp(_hero.position.x + delta * _scrollSpeed, _hero.position.y);

    // update the timers
    _sinceTouch += delta;
    _sinceHit += delta;
    

  _hero.rotation = clampf(_hero.rotation, -30.f, 90.f);

  if (_hero.physicsBody.allowsRotation) {
    float angularVelocity = clampf(_hero.physicsBody.angularVelocity, -2.f, 1.f);
    _hero.physicsBody.angularVelocity = angularVelocity;
  }

//  if ((_sinceTouch > 0.5f)) {
//    [_hero.physicsBody applyAngularImpulse:-40000.f*delta];
//  }

    _physicsNode.position = ccp(_physicsNode.position.x - (_scrollSpeed *delta), _physicsNode.position.y);
    //NSLog(@"%@", NSStringFromCGPoint(_physicsNode.position));


    // todo: optimize the repeated code
    // loop the lower limit
    for (CCNode *ground in _grounds0) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // actually, world position is the screen position; there is not need to do
        // the below conversion again
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];


        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
          ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
        }
    }
    // loop the upper limit
    for (CCNode *ground in _grounds1) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
        }
    }
    // loop the middle sensor
    for (CCNode *ground in _grounds2) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
        }
    }

  NSMutableArray *offScreenObstacles = nil;

  for (CCNode *obstacle in _obstacles) {
    CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:obstacle.position];
    CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];
    if (obstacleScreenPosition.x < -obstacle.contentSize.width) {
      if (!offScreenObstacles) {
        offScreenObstacles = [NSMutableArray array];
      }
      [offScreenObstacles addObject:obstacle];
    }
  }

  for (CCNode *obstacleToRemove in offScreenObstacles) {
    [obstacleToRemove removeFromParent];
    [_obstacles removeObject:obstacleToRemove];
    // for each removed obstacle, add a new one
    [self spawnNewObstacle];
  }
}

@end
