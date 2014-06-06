Bots With Dice!
===============

## What's the big idea?

Bots With Dice is a simple dice game. The idea is that you write code to play the game and then pit your code against all the other's code.

## How does the game work?

You have 100 hit points, and so does your opponent. Every roll of 2 through 6 is added to your accumulated attack damage. Your turn lasts up until you decide to attack with your accumulated damage or you roll a one.

To be friendly the simulator assumes you want to roll when your accumulated damage is at zero, and that you want to stop rolling once your accumulated damage is enough to kill your opponent outright.

## How do I take part?

1. Clone this repository.
1. Ensure you have ruby installed.
1. Edit my_bot.rb to improve it.
1. Run run.rb and find out how well you're doing.
1. Repeat!

Got a cool bot? Put a pull request in to add it!

## How does the simulator work out which bot is better?

The simulator runs your bot against each other bot between 1,000 and 2,000,000 times. To be fair, each bot gets to take turns starting each game. The simulator stops the match between two bots once the win rate gap between them exceeds the possible margin of error in the simulation to a confidence interval of 99.9%.