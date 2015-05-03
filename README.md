Transform
=============
**NOTE:**This is the new game. The original game idea was abandoned. The original game was in: https://github.com/JianJiao/WarOfLetters.git

Designed for iphone 6

* [Track Sprites](#trackSprites)
* [About the Game](#aboutTheGame)
* [Challenges](#challenges)
* [Notable Features](#notableFeatures)
* [Issue Tracking and Logs](#issueTrackingAndLogs)

<a id="trackSprites"></a>
## Track Sprites:
1. angel: http://www.spriters-resource.com/psp/lunarsilverstarharmony/sheet/58471/
2. bomb: http://www.spriters-resource.com/playstation/crashbandicoot3warped/sheet/57009/
3. shark: http://www.spriters-resource.com/3ds/epicmickeypowerofillusion/sheet/62880/
4. hawk: http://www.spriters-resource.com/arcade/dariusgaiden/sheet/39985/
5. ocean: http://www.stockunlimited.com/vector/background_1278758.html
6. rock: http://opengameart.org/content/low-poly-rocks
7. food: 
  http://www.spriters-resource.com/wii/bubbobplus/sheet/42891/
  http://www.spriters-resource.com/other_systems/supersmashbrosforwiiu/sheet/65137/

* angry bird: http://spritedatabase.net/game/2514
* underrwater: http://gilmec.deviantart.com/art/under-the-sea-BG-328371781
* running man: http://panku-kyouto.deviantart.com/art/Run-Sequence-Sprite-for-Juni-137374378

* Paid sprite kit:
    - http://graphicriver.net/item/sky-birds-game-assets/7127737
    - http://graphicriver.net/item/crazy-birds-game-ui-kit-/9094403
* the game is inspired by a game template of flappy bird from makeschool.com: 
  https://github.com/MakeSchool/FlappyFly-Spritebuilder.git

<a id="aboutTheGame"></a>
## About the Game
Infinite side scroller with shooting and transformation

* Control your hero
    •  Fly in the air or swim under the water 
    •  Transform into different forms
    •  Dodge & destroy enemies/Rocks

* Designed for iphone 6
* Used: 
    - Objective-C
    - Cocos2D
    - SpriteBuilder
    - Chimpmunk

<a id="challenges"></a>
## Challenges

* Infinite Horizontal Scrolling with Parallax
    •  Add sprites as children to container or physics nodes
    •  Constantly move container & physics nodes backwards •  Give container and physics nodes different velocity

* Management of Different Objects
    •  Create inheritance hierarchy of classes
    •  Spawn enemies in a fixed-,me/ fixed-distance manner •  Add off-screen invisible barrier to remove objects

* PosiCon-based transformaCon and reacCon
    •  Add invisible sensors to separate the game scene
    •  Set corresponding flags based on collision and posi,on •  Load different ,melines based on posi,on flags


<a id="notableFeatures"></a>
## Notable Features

* Transformation Animation
    •  Single hero, different forms
    •  Transform into human, fish, bird and angel


* Dive into the Ocean, Fly in the Sky
    •  Jump between the ocean and the sky
    •  Experience different gravi,es, in different forms

* Get more Bonus TransformaCons
    •  Destroy enemies and unlock bonuses
    •  Get more power and new transforma,ons from the
    bonuses
    •  More surprises as you go!



<a id="issueTrackingAndLogs"></a>
## Issue Tracking and Logs:



### cannot change the position of a sprite(its representation format:%, .)
The position of a sprite should be relative to its parent node. 
* so if the node itself is a single sprite, the sprite doesn't have a parent. In 
  this case it doesn't make sense to change its position because position is relative
  and there is nothing to compare to.
* when you have a node and it contains sprites, then you can change the position and 
  the representation format of the position of the sprites relative to the node.

### ccb file, spriteBuilder, didLoadFromCCB <br/> collision type not working

* Problem: 
  * you have a super class to act as an interface; you have sub classes 
    inplementing it
  * you have corresponding ccb files for the subclasses in spriteBuilder, but
    no such thing for the superclass
  * you set the collision type in the didLoadFromCCB method in the super class
  * it doesn't work

* Reason:
  * the didLoadFromCCB method is only called when the ccb file is loaded
  * you don't have a ccb file in spriteBuilder for the superclass, thus the 
    method won't be called, so the type has not been set.




### public properties
when setting them, use self.propName = "...";
Just using propName="..." does not work.


### NSMutalbeArray is (null)
Before you use the array(add elements to the array), you should first allocate space 
for it:(whatever this is )
    _enemies1 = [NSMutableArray array];


### Import! You have to first import a class to use it in a script!<br/>CCBReader: missing `[`at start of message send expression
This weird error message: CCBReader missing at start of message send expression
This is because you didn't import it


###  unrecognized selector sent to instance, custom class
This message means you are calling a method that doesn't exist in the instance.  
But you have clearly defined the method, then why is that?
Because you load the instance from spriteBuilder, and you didn't set the correct custom class in spriteBuilder

### rock spawned only once
Not actually, you didn't see it because you set the position of it realtive to the physicsnode(? since you add it 
to the physics node as a child and then it will appear), but the physics node is constantly moving leftward

### collision not detected
**Double**
You have to enable physics to make it work

### when you enable physics, it has to be a child of a physics node

### animation or effect doesn't happen
Didn't save or publish in spriteBuilder

### Game slow down
The game suddenly gets extremely slow: might be that you should charge your 
computer

### check dynamic class type
isKindOfClass

### replace the hero with a bigger sprite
If you replace it with a new class(load, add to the scene, remove the previous one, and reassign), you have to copy all the previous states of the hero.


### iphone resolution:
http://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
e.g. iphone6, the background picture should be 640*1136, double the initial points


### add physics node to physics node, crash on device
Runs well on the computer, crashes on device. 
Turns out you have to set the missile to sensor. Or it will crash when you add
the missile to the physicsnode.
```
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"missile";
    self.physicsBody.sensor = YES;
}
```


### strange collision
The unremoved invisible explosion class. The explosion class will become invisible after the timeline animation. But it is not removed from the scene. 
That's why you sometimes encounter strange collision. 


### multiple collision at one time
Could be the node not successfully removed from parent. Add a flag to the node donating whether it has been removed or not.


### true TRUE false FALSE might be a source of bug


### touch location


```
    - (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
    {
        //get the x,y coordinates of the touch
        CGPoint touchLocation = [touch locationInNode:self];

        //get the Creature at that location
        Creature *creature = [self creatureForTouchPosition:touchLocation];

        //invert it's state - kill it if it's alive, bring it to life if it's dead.
        creature.isAlive = !creature.isAlive;
    }

```


### launch penguin

    - (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
        [self launchPenguin];
    }

    - (void)launchPenguin {
    // loads the Penguin.ccb we have set up in Spritebuilder
    CCNode* penguin = [CCBReader load:@"Penguin"];
    // position the penguin at the bowl of the catapult
    penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));

    // add the penguin to the physicsNode of this scene (because it has physics enabled)
    [_physicsNode addChild:penguin];

    // manually create & apply a force to launch the penguin
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
    }



### the location and moving in flappyBird

#### Moving:  

physics node <>-- bird  
             <>-- ground and the like  
We move the whole physics node left constantly. It never goes back. 
  * Question: will it reach a limit?  

Since bird and ground are all children of the physics node, they will be also moved to the left together with the physics node.
  * For ground and alike: once it's moved out of the screen, we move it back to the right start of the 
    screen(thus it will appear to the screen again since we are constantly moving it leftward)
  * For bird: we don't want it to move. So while moving it leftward, we shall move it to the right in the same speed. 

#### position:

* I think the position of the hero is relative to the physics node, so it keeps increasing
* while your touch position is relative to the screen 
* we can use convertToWorldSpace to convert it to the screen position
  * convertToWorldSpace A B  
    Will convert B to screen point, assuming that B is the point in the context of node A
  * convertToNodeSpacd A B  
    Will convert B to position relative to A, from the world point B. 
  * reference:   
    http://www.cocos2d-x.org/wiki/Coordinate_System#Coordinate-System


### physics node scale

* when you enalbe physics, you cannot set scale
* just scale the initial picture first use preview


### physics shape outline not right
Center of the physics shape outline does not match the center of the picture


### Logs:

1. Forces like angular forces are applied inside update method, that's why
  it keeps bumping up on the ground.

2. [Important!]Change in the main scene, not the character.ccb!!!
  Why the lower half of your character is inside the ground?
  Reason: you didn't change the character you put in the main scene! 
    Only Changing nodes or sprites in the character.ccb file will not
    automatically reflect everything in the main scene! Weird.

    * it is the exact same thing with rotation:
      * it is not enough to set not allow rotation in the ccb file,
        you have to set it in the main scene!

3. setting the position.y
  * some methods work only for points, not percentage. What you set in 
    spriteBuilde should be in accordance with code in Xcode






