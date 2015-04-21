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
#import "Missile.h"
#import "Enemy.h"
#import "Enemy1.h"
#import "Enemy2.h"
#import "Rock.h"


static const CGFloat firstEnemyPosition = 280.f;
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
    CCNode* _movingNode;

    CCNode *_ground1, *_ground2, *_ground3, *_ground4,*_ground5, *_ground6, *_ground7;
    CCNode *_ocean0, *_ocean1;

    NSArray *_grounds0, *_grounds1, *_grounds2;
    NSArray *_oceans;

    NSTimeInterval _sinceTouch;
    NSTimeInterval _sinceHit, _sinceLoad;
    

    NSMutableArray *_obstacles;
    NSMutableArray *_enemies1;
    NSMutableArray *_enemies2;
    NSMutableArray *_missiles;

    CCButton *_restartButton;

    BOOL _gameOver;

    CGFloat _scrollSpeed0, _scrollSpeed1;

    NSInteger _points;
    CCLabelTTF *_scoreLabel;
    
    NSString *charPosition;
    
    NSString *atRoof;
    NSString *atGround;
    NSString *atUpper;
    NSString *atLower;
    
    NSString *enemy1;
    NSString *enemy2;
    
    CGPoint downGravity, upGravity;
    
    float yVelocity;
}



- (void)didLoadFromCCB {
    _scrollSpeed0 = 80.f;
    _scrollSpeed1 = 40.f;
    _sinceLoad = 0.f;
  self.userInteractionEnabled = YES;

    _grounds0 = @[_ground1, _ground2];
    _grounds1 = @[_ground3, _ground4];
    _grounds2 = @[_ground5, _ground6];
    _oceans = @[_ocean0, _ocean1];
    
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
    
    enemy1 = @"Enemy1";
    enemy2 = @"Enemy2";
    
    downGravity = ccp(0.0, -100.0);
    upGravity = ccp(0.0, 100);



    // set this class as delegate
    _physicsNode.collisionDelegate = self;
    // set collision type
    _hero.physicsBody.collisionType = @"hero";
    _hero.zOrder = DrawingOrdeHero;

//  _obstacles = [NSMutableArray array];
//  [self spawnNewObstacle];
//  [self spawnNewObstacle];
//  [self spawnNewObstacle];
    _missiles = [NSMutableArray array];
    _enemies1 = [NSMutableArray array];
    [self spawnNewEnemyWith:enemy1 and:_enemies1];
    [self spawnNewEnemyWith:enemy1 and:_enemies1];
    [self spawnNewEnemyWith:enemy1 and:_enemies1];

    _enemies2 = [NSMutableArray array];
    [self spawnNewEnemyWith:enemy2 and:_enemies2];
    [self spawnNewEnemyWith:enemy2 and:_enemies2];
    [self spawnNewEnemyWith:enemy2 and:_enemies2];
    
    
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
              // load particle effect
              CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"bombExplosion"];
              // make the particle effect clean itself up, once it is completed
              explosion.autoRemoveOnFinish = TRUE;
              // place the particle effect on the seals position
              explosion.position = _hero.position;
              // add the particle effect to the same node the missile is on
              [_hero.parent addChild:explosion];
              [_hero performSelector:@selector(startFish) withObject:nil afterDelay:0.f];
          }else if([charPosition isEqualToString:atLower]){
              // if at lower space, apply downward force
              [_hero.physicsBody applyImpulse:ccp(0, -130.f)];
          }else if([charPosition isEqualToString:atUpper]){
              // if at upper space, apply upward force
              [_hero.physicsBody applyImpulse:ccp(0, 130.f)];
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
              // load particle effect
              CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"toAngel"];
              // make the particle effect clean itself up, once it is completed
              explosion.autoRemoveOnFinish = TRUE;
              // place the particle effect on the seals position
              explosion.position = ccp(_hero.position.x + 24.0f, _hero.position.y);
              [_hero.parent addChild:explosion];
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
    CGPoint force = ccpMult(launchDirection, 60);
    [missile.physicsBody applyForce:force];
    [_missiles addObject:missile];
    //NSLog(@"initial array: %@", _missiles);
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
    
    // load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"bombExplosion"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the seals position
    explosion.position = hero.position;
    // add the particle effect to the same node the missile is on
    [hero.parent addChild:explosion];
    // become a handsome young man again
    [_hero performSelector:@selector(startHuman) withObject:nil afterDelay:0.f];

  return YES;
}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero enemy:(CCNode *)enemy {
    [self gameOver];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair missile:(CCNode *)missile enemy:(CCNode *)enemy {
    Enemy *en = (Enemy *) enemy;
    if(!en.myType){
        NSLog(@"oh shit! null!");
    }
    [self tryRemoveTheMissile: missile];
    [self tryRemoveEnemy:en];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero rock:(CCNode *)rock {
    [self gameOver];
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair missile:(CCNode *)missile wildcard: (CCNode *) anything{
    [self tryRemoveTheMissile: missile];
    return YES;
}

- (void) tryRemoveTheMissile: (CCNode*) missile{
    // load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"bombExplosion"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the seals position
    explosion.position = missile.position;
    // add the particle effect to the same node the missile is on
    [missile.parent addChild:explosion];
    
    // finally, remove the destroyed missile
    [missile removeFromParent];
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
    
    // load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"toAngel"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the seals position
    explosion.position = ccp(hero.position.x + 24.0f, hero.position.y);
    [hero.parent addChild:explosion];

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
        
        // load particle effect
        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"toFish"];
        // make the particle effect clean itself up, once it is completed
        explosion.autoRemoveOnFinish = TRUE;
        // place the particle effect on the seals position
        explosion.position = ccp(hero.position.x + 24.0f, hero.position.y);
        [hero.parent addChild:explosion];


    }else{
        // at lower space
        // turn gravity upward, set char position at lower
        // turn into a fish
        _physicsNode.gravity = upGravity;
        charPosition = atLower;
        [_hero performSelector:@selector(startFish) withObject:nil afterDelay:0.f];
        
        // load particle effect
        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"toFish"];
        // make the particle effect clean itself up, once it is completed
        explosion.autoRemoveOnFinish = TRUE;
        // place the particle effect on the seals position
        explosion.position = ccp(hero.position.x + 24.0f, hero.position.y);
        [hero.parent addChild:explosion];


        
    }
    
    
    return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero goal:(CCNode *)goal {
  [goal removeFromParent];

  _points++;
  _scoreLabel.string = [NSString stringWithFormat:@"%d", (int)_points];

  return YES;
}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair barrier:(CCNode *)barrier wildcard:(CCNode *)anything {
    [anything removeFromParent];
    NSLog(@"collision detected");
    return YES;
}

#pragma mark - Game Actions

- (void)gameOver {
  if (!_gameOver) {
      _scrollSpeed0 = 0.f;
      _scrollSpeed1 = 0.f;
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

//#pragma mark - Obstacle Spawning
//
//- (void)spawnNewObstacle {
//  CCNode *previousObstacle = [_obstacles lastObject];
//  CGFloat previousObstacleXPosition = previousObstacle.position.x;
//
//  if (!previousObstacle) {
//    // this is the first obstacle
//    previousObstacleXPosition = firstObstaclePosition;
//  }
//
//  Obstacle *obstacle = (Obstacle *)[CCBReader load:@"Obstacle"];
//  obstacle.position = ccp(previousObstacleXPosition + distanceBetweenObstacles, 0);
//  [obstacle setupRandomPosition];
//  obstacle.zOrder = DrawingOrderPipes;
//  [_physicsNode addChild:obstacle];
//  [_obstacles addObject:obstacle];  // _obstacles is a collection
//}

#pragma mark - enemy Spawning

- (void)spawnNewEnemyWith: (NSString*) enemyType and: (NSMutableArray*) enemies{
    if(!enemyType){
        NSLog(@"this seems impossible");
    }else{
        CCNode *previousEnemy = [enemies lastObject];
        CGFloat previousEnemyXPosition = previousEnemy.position.x;
        
        if (!previousEnemy) {
            // this is the first obstacle
            previousEnemyXPosition = firstEnemyPosition;
        }
        
        Enemy *enemy = (Enemy *) [CCBReader load:enemyType];
        //    enemy.physicsBody.collisionType=@"enemy";   // why can't I set this with the class: did load from ccb
        if(!enemy.myType){
            NSLog(@"the new one is not correct");
        }
        enemy.position = ccp(previousEnemyXPosition + distanceBetweenObstacles, 0);
        [enemy setupRandomPositionWith: enemyType];
        enemy.zOrder = DrawingOrderPipes;
        [_physicsNode addChild:enemy];
        [enemies addObject:enemy];  // _obstacles is a collection
        // keep reference to each enemy in a collection
    }
}


- (NSMutableArray*) findOffscreenObjsInArray: (NSMutableArray*) objs{
    NSMutableArray *offScreenObjs = nil;
    for (CCNode *obj in objs) {
        CGPoint objWorldPosition = [_physicsNode convertToWorldSpace:obj.position];
        CGPoint objScreenPosition = [self convertToNodeSpace:objWorldPosition];
        // why the content size?
        // because we use the left corner of the node as the anchor. Only when the left corner
        // is one complete width off the screen, the whole node is off screen
        if (objScreenPosition.x < -obj.contentSize.width) {
            if (!offScreenObjs) {
                offScreenObjs = [NSMutableArray array];
            }
            [offScreenObjs addObject:obj];
        }
    }
    return offScreenObjs;
}


- (void) tryRemove: (NSString*) enemyType From: (NSMutableArray*) objs{
    NSMutableArray *offScreenObjs = nil;
    if(!enemyType){
        NSLog(@"null! dude, another one");
    }
    offScreenObjs = [self findOffscreenObjsInArray:objs];
    for (CCNode *objToRemove in offScreenObjs) {
        [objToRemove removeFromParent];
        [objs removeObject:objToRemove];
        // for each removed obstacle, add a new one
        [self spawnNewEnemyWith: enemyType and: objs];
    }
}

// this name is somehow problematic
//- (void)remove: (NSString*) enemyType From: (NSMutableArray*) objs{
//    NSMutableArray *offScreenObjs = nil;
//    
//    for (CCNode *obj in objs) {
//        CGPoint objWorldPosition = [_physicsNode convertToWorldSpace:obj.position];
//        CGPoint objScreenPosition = [self convertToNodeSpace:objWorldPosition];
//        if (objScreenPosition.x < -obj.contentSize.width) {
//            if (!offScreenObjs) {
//                offScreenObjs = [NSMutableArray array];
//            }
//            [offScreenObjs addObject:obj];
//        }
//    }
//    for (CCNode *objToRemove in offScreenObjs) {
//        [objToRemove removeFromParent];
//        [objs removeObject:objToRemove];
//        // for each removed obstacle, add a new one
//        [self spawnNewEnemyWith: enemyType and: objs];
//    }
//}


#pragma mark - spawnRock
- (void) spawnRock{
    Rock *rock = (Rock *) [CCBReader load:@"Rock"];
    float anchorX = _hero.position.x + 200;
    rock.position = ccp(anchorX, 0);
    [rock setupRandomPosition];
    rock.zOrder = DrawingOrderPipes;
    [_physicsNode addChild:rock];
}

//
//#pragma mark - enemy Spawning
//
//- (void)spawnNewEnemyWith: (NSString*) enemyType and: (NSMutableArray*) enemies{
//    if(!enemyType){
//        NSLog(@"this seems impossible");
//    }else{
//        CCNode *previousEnemy = [enemies lastObject];
//        CGFloat previousEnemyXPosition = previousEnemy.position.x;
//        
//        if (!previousEnemy) {
//            // this is the first obstacle
//            previousEnemyXPosition = firstEnemyPosition;
//        }
//        
//        Enemy *enemy = (Enemy *) [CCBReader load:enemyType];
//        //    enemy.physicsBody.collisionType=@"enemy";   // why can't I set this with the class: did load from ccb
//        if(!enemy.myType){
//            NSLog(@"the new one is not correct");
//        }
//        enemy.position = ccp(previousEnemyXPosition + distanceBetweenObstacles, 0);
//        [enemy setupRandomPositionWith: enemyType];
//        enemy.zOrder = DrawingOrderPipes;
//        [_physicsNode addChild:enemy];
//        [enemies addObject:enemy];  // _obstacles is a collection
//        // keep reference to each enemy in a collection
//    }
//}


#pragma mark - Update

- (void)update:(CCTime)delta {
  // clamp velocity
    if([charPosition isEqualToString:atUpper] || [charPosition isEqualToString:atRoof]){
        yVelocity = clampf(_hero.physicsBody.velocity.y, -1*MAXFLOAT, 60.f);
    }else{
        yVelocity = clampf(_hero.physicsBody.velocity.y, -60.f, MAXFLOAT);
    }
    
    _hero.physicsBody.velocity = ccp(0, yVelocity);
    _hero.position = ccp(_hero.position.x + delta * _scrollSpeed0, _hero.position.y);
    _ground7.position = ccp(_ground7.position.x + delta * _scrollSpeed0, -5);
    

    // update the timers
    _sinceTouch += delta;
    _sinceHit += delta;
    _sinceLoad +=delta;
    if(_sinceLoad >= 2.0f){
        [self spawnRock];
        _sinceLoad = 0.f;
    }
    

    _hero.rotation = clampf(_hero.rotation, -30.f, 90.f);

  if (_hero.physicsBody.allowsRotation) {
    float angularVelocity = clampf(_hero.physicsBody.angularVelocity, -2.f, 1.f);
    _hero.physicsBody.angularVelocity = angularVelocity;
  }


    _physicsNode.position = ccp(_physicsNode.position.x - (_scrollSpeed0 *delta), _physicsNode.position.y);
    _movingNode.position = ccp(_movingNode.position.x - (_scrollSpeed1 *delta),_movingNode.position.y);


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
    
    // loop the oceans
    for (CCNode *ocean in _oceans) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [_movingNode convertToWorldSpace:ocean.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ocean.contentSize.width)) {
            ocean.position = ccp(ocean.position.x + 2 * ocean.contentSize.width, ocean.position.y);
        }
    }
    [self tryRemove:enemy1 From:_enemies1];
    [self tryRemove:enemy2 From:_enemies2];
    [self tryRemoveMissiles];

}

// just remove the selected enemy
- (void) tryRemoveEnemy: (Enemy*) enemy{
    NSMutableArray* enemies;
    NSString *theType = enemy.myType;
    if(!theType){
        NSLog(@"null, problem here");
    }
    if([theType isEqualToString:enemy1]){
        enemies = _enemies1;
    }else if([theType isEqualToString:enemy2]){
        enemies = _enemies2;
    }
    [enemy removeFromParent];
    [enemies removeObject:enemy];
    [self spawnNewEnemyWith:theType and:enemies];
}

- (void) tryRemoveMissiles{
    NSMutableArray *offScreenObjs = nil;
   // NSLog(@"array: %@", _missiles);
    offScreenObjs = [self findOffscreenMissilesInArray:_missiles];
    for (CCNode *objToRemove in offScreenObjs) {
        [objToRemove removeFromParent];
        [_missiles removeObject:objToRemove];
    }

}

- (void) tryRemoveRock:(CCNode *) rock{
    [rock removeFromParent];
}

// missiles are different, you should check the right side and the left side
- (NSMutableArray*) findOffscreenMissilesInArray: (NSMutableArray*) objs{
    NSMutableArray *offScreenObjs = nil;
    for (CCNode *obj in objs) {
        CGPoint objWorldPosition = [_physicsNode convertToWorldSpace:obj.position];
        CGPoint objScreenPosition = [self convertToNodeSpace:objWorldPosition];
        // why the content size?
        // because we use the left corner of the node as the anchor. Only when the left corner
        // is one complete width off the screen, the whole node is off screen

        if (objScreenPosition.x < -obj.contentSize.width || objScreenPosition.x > 300) {
            if (!offScreenObjs) {
                offScreenObjs = [NSMutableArray array];
            }
            [offScreenObjs addObject:obj];
        }
    }
    return offScreenObjs;
}



@end
