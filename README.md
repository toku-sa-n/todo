# todo
A CLI Todo application for Linux users.
## Feature
* Break your todo into several subtodos.

  You can add subtodos, which clearfy what you have to do. For example, suppose that you have to clean your room. What you have to do is these three things.
  
  * Clean your desk
  * Sort your garbage
  * Go to garbage
  
  Let's add these things like this.
  ```
  >todo add "Clean my room"
  >todo show
  1 □ Clean my desk
  >todo subtodo 1 "Clean my desk"
  >todo show
  1 □ Clean my room
  2 -> □ Clean my desk
  >todo subtodo 1 "Sort my garbage"
  >todo subtodo 1 "Go to garbage"
  >todo show
  1 □ Clean my room
  2 -> □ Go to garbage
  3 -> □ Sort my garbage
  4 -> □ Clean my desk
  ```
  Or usually, you clean your desk first of all, sort your garbage and go to garbage. So you can also add these todos like this.
  ```
  >todo add "Clean my room"
  >todo subtodo 1 "Clean my desk"
  >todo subtodo 2 "Sort my garbage"
  >todo subtodo 3 "Go to garbage"
  >todo show
  1 □ Clean my room
  2 -> □ Clean my desk
  3 --> □ Sort my garbage
  4 ---> □ Go to garbage
  ```
  This feature will improve your productivity.
## How to use
Please see ```todo help```.
## Install and Uninstall
``` sudo make install ``` and ```sudo make uninstall```
