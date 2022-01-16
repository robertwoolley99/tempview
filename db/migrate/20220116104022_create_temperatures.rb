# frozen_string_literal: true

# Migration to create Temperature table to hold max/min temps.
class CreateTemperatures < ActiveRecord::Migration[7.0]
  def change
    create_table :temperatures do |t|
      t.float :min_temp
      t.float :max_temp

      t.timestamps
    end
  end
end
