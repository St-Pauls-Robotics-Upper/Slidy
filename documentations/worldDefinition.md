# World File Difinitions

this game use .txt file for levels. Each .txt file defines the grid size, the position and move limits of both players, and the appearance of the world. 
The format is listed below: 

```
[World Width],[World Height]
[playerA starting x pos],[playerA starting y pos],[playerA move limit]
[playerB starting x pos],[playerB starting y pos],[playerB move limit]
[world appearance (multiline string)]
```
Note: x is zero at top left, and direction down is +; y is zero at top left, and direction right is +

The world appearance part is noted by multiline string, in which: 
* ```spacebar``` marks empty, player can move in that position
* ```x``` marks blockage, player cannot go to that position
* any unreconizable character will be treated as a empty space. 

Note: More is comming

A fully written world file sould look like this: 

```
5,6
2,0,6
4,5,7
xx xx
xx xx
xx xx
     
 x x 
   x 
```
The first line ```5,6``` means the grid is 5x6.
The second line means player A start at ```2,0```, and have ```6``` moves.
The third line means player B start at ```4,5```, and have ```7``` moves.

The world will look this: 
![Image of example world](/documentations/images/worldExample1.png)
