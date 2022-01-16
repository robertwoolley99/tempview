# frozen_string_literal: true

class TemperaturesController < ApplicationController
  def index
    @temperature = Temperature.last
  end
end
