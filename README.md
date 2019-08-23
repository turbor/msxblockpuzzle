# msxblockpuzzle
MSX1 block puzzle . Let's see how much we can cram in 16 KB cartridge...
This is an attempt to create a MSX1 game that would run on a simple standard machine.

It is a simple game, you need to place the blocks in the grid in the attempt to fill rows or columns.
There are 3 blocks available and you can use the 'M' key to switch between the blocks otherwise simply move the blocks using the cursor keys and put it in place with the space key.

A lot of effort went into the visuals:
 - A 1 pixel scroller with multiple fonts each time the intro text is scrolling
 - Animated score counter
 - Animated block removal
 - Bird sprites that nicely moves into screen and out again using the EC bit.
 - Animated supportive texts when multiple lines are removed
 - And the some more ...
