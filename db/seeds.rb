# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# We will set up a database for each environment.
# It will be single row table for Temperature - we will set the range slightly differently between environments
# This will help us with testing.

temp = Temperature.new
temp.id = 1
temp.min_temp = 20
temp.max_temp = 30
temp.save
