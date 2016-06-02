#Conways Game of Life

####Ruby-Version: 2.0+

Requirements: Gosu.  Gosu is a Ruby graphics library written in C+, so unlike most gems it must be compiled natively.  [Gosu Mainsite](https://www.libgosu.org/)

To run - clone repo, navigate to directory and `ruby game.rb`

This is a zero player game - used to similate population growth and decay.  The "board" here is a 2 dimensional grid style array.

###Rules:

1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by over-population.
4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

Mouseclick anywhere on the grid to add a "live cell." Click again on a living cell to mark it as "dead". Pressing spacebar will start the simulation, pressing while its running will pause it.  Pressing the left and right arrow keys will change the unit of time between each cycle, effectively speeding up or slowing down the simulation.


![Picture of Simple Pattern in Application](http://i.imgur.com/TYX78e0.png)


