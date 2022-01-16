# frozen_string_literal: true

# Controller for Temperatures object
class TemperaturesController < ApplicationController
  def index
    @temperature = Temperature.find(1)
  end

  def update
    params_permit = params[:temperature].permit(:max_temp, :min_temp)
    params_hash = params_permit.to_h
    @float_hash_params = params_hash.transform_values(&:to_f)
    complete_update and return if @float_hash_params['max_temp'] > @float_hash_params['min_temp']

    flash[:temp_notice] = 'The minimum temperature must be less than the maximum temperature.'
    redirect_back(fallback_location: '/')
  end

  private

  def complete_update
    @temperature = Temperature.find(1)
    @temperature.with_lock do
      @temperature.update(max_temp: @float_hash_params['max_temp'], min_temp: @float_hash_params['min_temp'])
    end
    redirect_back(fallback_location: '/')
  end
end
