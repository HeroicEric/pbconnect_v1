# PBConnect

PBConnect is a tool that is meant to be used to help paintball players and paintball teams connect with one another as well as help to manage existing paintball teams. This will provide a number of tools that will help teams schedule and organize practices with themselves as well as with other teams. This will also provide a place for 'free agents' to list themselves as available so that teams who are looking for new players can more easily find players that are close to their location.

### Demo

[http://pbconnect.herokuapp.com/](http://pbconnect.herokuapp.com/)

## Why?

I wrote this project because I see a problem that currently needs to be solved and thought that this would be a good opportunity to get some development practice with rails regardless of whether or not the idea proves to be something that others are interested in. 

This topic is something that I personally have an interest in improving so I think that I am in a good position to understand the needs of my target audience.

This project was also a good way to force myself to stop trying to read everything and make sure that all my code would be perfect, which was really keeping me from actually making anything. I've learned a lot already and it's now easy to understand that reading/learning about things is only half the battle. To truly understand how things work, I need to spend time playing around and making mistakes.

## Installation

    bundle install

Then you'll run the migrations with

	rake db:migrate

## Testing

The tests are written using RSpec. 

You can run the tests with the following:
  
    rspec spec

Ideally you will run the tests using the spin and kicker gems. Install the gems using the following:

    gem install spin kicker

Start by starting up the spin server with

    spin serve

Then, in another terminal window, start up kicker with the following:

    kicker -r rails -b 'spin push'

Now your specs will run automatically whenever you change a file, and they will run faster this way than loading up the environment each time from scratch.

## Test Data
You can import some sample data by using the seed rake task.

    rake db:seed