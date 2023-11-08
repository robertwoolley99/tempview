# README

# Tempview

## Requirements:
Runs in Ruby version 3.1.1 on Rails 7.1
## Installation

i) Clone this repo with `git clone https://github.com/robertwoolley99/tempview.git`

ii) Ensure you have Ruby 3.1.1 installed; then in rvm `rvm use 3.1.1`

iii) Now install the gems with `bundle install`

iv) Install, migrate and seed the database with `rails db:setup`

v) Then in a terminal add your WeatherAPI key with `export WEATHER_API_KEY=`

vi) Start the server (in development mode) with `rail s` 

Navigate to http://localhost:3000

## How To Use

i) Set temperatures - enter your preferred temperatures in the relevant boxes and click 'Update Maximum and Minimum Temperatures'. Temperatures can be entered in 0.1 degree increments; Please note than the maximum temperature must be higher than the minimum temperature

Tempview will confirm if the setting is valid and flash a message to confirm that the update succeeded (or didn't).

ii) Find out if it is hot,cold or warm: Enter a valid UK post code in the 'Enter Postcode' box.  Tempview will validate the postcode with postcodes.io.
If the postcode isn't valid then Tempview will tell the user and ask for a correct postcode.  If postcodes.io is down or the postcode is valid, then Tempview will check the temperature at that postcode. It will then return a message as to whether the temperature at the location is hot, warm or cold. If WeatherAPI is down then Tempview will flash a suitable message.


## Tests
To run tests, run `rspec` in the tempview root directory.  There are two sets of tests:

a) Unit Tests - these cover the key services of `weather_service, post_code_checker_service, post_code_and_weather_service` as well as the model for `temperature`.

b) Integration Tests - these cover all interactions from the front end in terms of all outcomes.
