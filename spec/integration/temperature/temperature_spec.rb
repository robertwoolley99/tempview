require 'rails_helper'

RSpec.describe 'Temperature Range', type: :feature do
  context 'set the max min ranges' do
    before(:each) do
      temp = Temperature.new
      temp.id = 1
      temp.min_temp = 20
      temp.max_temp = 30
      temp.save
    end
    it 'works when things are correct' do
      visit '/'
      fill_in 'temperature_min_temp', with: -10.0
      fill_in 'temperature_max_temp', with: 30.0
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_min_temp', with: "-10.0")
      expect(page).to have_field('temperature_max_temp', with: "30.0")
    end
  end
end
