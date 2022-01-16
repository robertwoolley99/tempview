# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# We will set up a database for each environment.
# It will be single row table for Temperature - we will set the range slightly differently between environments
# This will help us with testing.

# Exit if database already exists
begin
  ActiveRecord::Base.connection
rescue ActiveRecord::NoDatabaseError
  Rails.logger.debug 'Database does not exist - ok to seed it'
else
  Rails.logger.debug 'Database already exists. Exiting to prevent breaking it'
end

temp = Temperature.new

case ENV['RAILS_ENV']
when 'test'
  temp.min_temp = 0
  temp.max_temp = 25
  temp.save
when 'development'
  temp.min_temp = 20
  temp.max_temp = 30
  temp.save
end
