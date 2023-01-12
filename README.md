# WIN8051
<br/>

## Period

- In 2021, the second semester of the second grade

## Contents

**1. 21_10_08_Code.asm**

- Sequential representation of alphabets A, E, I, O, and U through 7 segments of WIN8051.


**2. 21_10_15_Code.asm**

- BCD_Code the remainder obtained through the division operation of two numbers using the 7 segments of WIN8051 and the two numbers are converted and output.


**3. 21_10_29_Code.asm**

- Using the Dot Matrix on WIN8051 to print out two points rotating the edges


**4. 21_11_12_Code.asm**

- Enter two numbers using the keypad of WIN8051 and output the remainder of the division operation through 7 segments.


**5. 21_11_19_Code.asm**

- Move the letters on the LCD of the WIN8051 to the left at regular intervals


**6. Final_Project_Code.asm**

- Basic functions

  - A Snake Game with only one body from start to finish -> **Clear**
  
  - Control up, down, left and right with key pad (ex. 1, 4, 6, 9) -> **Clear**
  
  - Feeding should appear randomly (how to implement random numbers: timer x (minority excluding 2)) -> **Clear**
  
  - The body should be green, the food should be red, and the score should be increased by 1 on the 7-segment array when fed  -> **Clear**
  
  - If you hit the wall, the game is over -> **Clear**
  
  
- Additional functions

  - At the same time as the game starts, a stopwatch that is powered by a timer on the LCD and the number goes up exactly every second. No minutes required (15 points) -> **Partially implemented**
  
  - Display the phrase 'Press Any Key to Start' on the LCD at the start of the game, and the phrase 'Game Over' on the top line of the LCD at the time of death should blink red with the stopwatch time output at the end (10 points) -> **Clear**
  
  - Post PAUSE stationery on LCD while pausing game and stopwatch with INT0 button (15 points) -> **Partially implemented**
  
  - Reset the game when you press the A button on the keypad (10 points) -> **Clear**
