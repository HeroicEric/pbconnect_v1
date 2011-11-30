# PBConnect

PBConnect is a social network for paintball players and teams find each other, keep in touch, and schedule meetings.
________________________

# Installation

  bundle install

________________________

# Testing

The tests are written using RSpec. 

You can run the tests with the following:
  
  rspec spec

Ideally you will run the tests using the spin and kicker gems. Start by starting up the spin server with

  spin serve

Then, in another terminal window, start up kicker with the following:

  kicker -r rails -b 'spin push'

Now your specs will run automatically whenever you change a file, and they will run faster this way than loading up the environment each time from scratch.