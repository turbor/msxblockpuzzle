# blockpuzzle
MSX1 block puzzle.
This is an attempt to create a MSX1 game that would run on a simple standard machine with 16KB of ram.
When the music was added the 16KB rom boundary was broken and since I didn't want to start fidling with compression it is now a 32KB rom.

It is a casual puzzle game, you need to place the blocks in the grid in the attempt to fill rows or columns.
There are 3 blocks available and you can use the 'M' key to switch between the blocks otherwise simply move the blocks using the cursor keys and put it in place with the space key.
Once the 3 pieces are placed on the grid, 3 random new pieces will be selected.
Extra points are rewarded if multiple lines are removed at once.
The difficulty selection influences the changes of the blocks that will be selected at random.

A lot of effort went into the visuals:
 - A 1 pixel scroller with multiple fonts each time the intro text is scrolling
 - Animated score counter
 - Animated block removal
 - Bird sprites that nicely moves into screen and out again using the EC bit.
 - Animated supportive texts when multiple lines are removed
 - A NeoGeo like demonstration mode showing the keys used to play the game.
 - And then some more ...

The two music pieces included are
 - Two Part Inventions No 13, by J. S. Bach
 - The Funeral March, by Frederic Chopin


