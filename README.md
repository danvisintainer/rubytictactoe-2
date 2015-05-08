# rubytictactoe-2

A try at Ruby object-oriented Tic-Tac-Toe!

## Running it

You must have Ruby installed to play. Clone the repository to your computer, navigate to its root directory, and run:

```bash
ruby bin/tictactoe
```

## Features

- "X" and "O" are interchangeable players. One can be a human with the other played by the computer. Or, make them both humans. Or make them both computers! [Just remember...](http://share.danvisintainer.com/apcnewsharrison-ford-firewall_mainImage7.jpg7.jpg)
- The player who goes first is picked at random.
- The computer is "smart" in the sense that it'll immediately win if it can, but it'll also block its opponent from winning if possible.
- The size of the board is customizable - you can play an 81-space 9x9 Tic-Tac-Toe game! Or a 4-space 2x2 game.

## Future tasks / limitations

- Get testing (probably with RSpec) implemented
- Make the Ruby styling a little better
- As of right now, you can only 'properly' quit the app at the end of a game. However, ^C at any time will quit as well.
