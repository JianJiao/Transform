PM meeting note:

WEEK 1: Finish all animations for the hero and logic. check!

1. find all four sets of sprites for four kinds of animations
2. when the hero is on the ground, select the human being animation  √
3. when the hero is in the lower space, select the fish animation    √
4. when the hero is in the upper space, select the bird animation    √
5. when the hero is in the cloud, select the angel animation         √

WEEK 2: Add enemies and bombs

1. add the bomb                        √
* change the missile-- bomb
* ajust the density of the bomb

2. add enemies                         √
* add dummy enemies that can interact with the bumb and player 
  * position the ememy randomly in the y coordinate
  * in each area, three in the horizontal screen
  * each area is separate, make the random generator accept area as a parameter

3. create the hierarchy of enemies    √
  * create a super class enemy that has the methods each type of enemy will share
  * create a fish enemy class that inherit from the super class and has its own sprites and make it live in the lower space
  * create a bird enemy class that inherit from the super class and has its own sprites and make it live in the upper space


WEEK 3: Add interactions between parts

1. add collision between bomb and enemy   √
  * clean up obstacles
  * remove missiles when collision happens
  * remove enemies when collision happens
  * create new enemies after removing one
2. remove offscreen missiles              √
  * remove offscreen missiles
  * refactor: extract the offscreen method
  * find and solve the setValue null bug


WEEK 4: fix bugs and polish game

1. deal with the collision pair myType null exception √
2. change background img √
3. tune the y velocity of different parts √
4. add new enemies that are not destroyable √
  * rocks as the sprites 
  * spawn rocks in a fixed intervals
5. rock collision with hero √
6. missile collision with anything √
7. remove offscreen rocks? √
8. add barrier to remove rocks?  √

WEEK 5: add bonus and better effects

1. particle effect              √
2. shooting from the big bird   √
3. bullet collision with hero   √
4. remove off screen bullets?   √
5. modify the clouds            √

WEEK 6: Fix and release the game.

1. bonus                                                      √
  * when shark disappears, load the diomand. 
  * exclude waterbonus from the wildcard of missile collision    
  * load bigger animation timeline when get water bonus
2. fix: solve the physics border problem with the timeline    √
3. the score board                                            √
4. the control scene where you can see your score             √
5. fix the particle effect slow down problem                  √
6. change sprites to make game look better                    √
7. add combo                                                  √





