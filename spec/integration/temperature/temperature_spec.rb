# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Temperature Range', type: :feature do
  context 'when setting the max min ranges' do
    before do
      temp = Temperature.new
      temp.id = 1
      temp.min_temp = 20
      temp.max_temp = 30
      temp.save
      visit root_path
    end

    it 'updates max temp correctly' do
      fill_in 'temperature_max_temp', with: 40.0
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_max_temp', with: '40.0')
    end

    it 'updates min temp correctly' do
      fill_in 'temperature_min_temp', with: -10.0
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_min_temp', with: '-10.0')
    end

    it 'tells us updates worked ok' do
      fill_in 'temperature_min_temp', with: -10.0
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_content('Update completed.')
    end

    it 'rejects a max temp which is not higher than min temp' do
      fill_in 'temperature_max_temp', with: 10
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_max_temp', with: '30.0')
    end

    it 'rejects a min temp which is not lower than max temp' do
      fill_in 'temperature_min_temp', with: 90
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_min_temp', with: '20.0')
    end

    it 'tell us to ensure that the max temp is greater than the min temp' do
      fill_in 'temperature_min_temp', with: 90
      click_button('Update Maximum and Minimum Temperatures')
      expect(page)
        .to have_content('The minimum temperature must be less than the maximum temperature. Please try again.')
    end
  end

  context 'when doing postcode weather lookups' do
    let(:pcaws_id) { instance_double PostCodeAndWeatherService }

    before do
      temp = Temperature.new
      temp.id = 1
      temp.min_temp = 20
      temp.max_temp = 30
      temp.save
      allow(PostCodeAndWeatherService).to receive(:new).and_return(pcaws_id)
      visit root_path
    end

    it 'will provide the correct message when we have cold weather' do
      fill_in 'postcode', with: 'RH2 8HR'
      allow(pcaws_id).to receive(:process).and_return({ status: 'ok', postcode: 'RH2 8HR', temp: '7.0' })
      click_button('Hot, Warm or Cold?')
      expect(page).to have_content('It is currently cold at RH2 8HR.')
    end

    it 'will provide the correct message when we have warm weather' do
      fill_in 'postcode', with: 'RH2 8HR'
      allow(pcaws_id).to receive(:process).and_return({ status: 'ok', postcode: 'RH2 8HR', temp: '22.0' })
      click_button('Hot, Warm or Cold?')
      expect(page).to have_content('It is currently warm at RH2 8HR.')
    end

    it 'will provide the correct message when we have hot weather' do
      fill_in 'postcode', with: 'RH2 8HR'
      allow(pcaws_id).to receive(:process).and_return({ status: 'ok', postcode: 'RH2 8HR', temp: '32.0' })
      click_button('Hot, Warm or Cold?')
      expect(page).to have_content('It is currently hot at RH2 8HR.')
    end

    it 'says when a postcode is not valid' do
      fill_in 'postcode', with: 'BOGUS'
      allow(pcaws_id).to receive(:process).and_return({ status: 'invalid_postcode', postcode: 'BOGUS', temp: nil })
      click_button('Hot, Warm or Cold?')
      expect(page)
        .to have_content("Sorry - BOGUS doesn't appear to be a valid UK postcode. Please try again with a valid UK postcode.")
    end

    it 'says when a postcode is empty' do
      fill_in 'postcode', with: ''
      allow(pcaws_id).to receive(:process).and_return({ status: 'fail_nil_postcode', postcode: '', temp: nil })
      click_button('Hot, Warm or Cold?')
      expect(page).to have_content('Postcode is blank. Please enter a valid UK postcode.')
    end

    it 'says when weather api is not available' do
      fill_in 'postcode', with: 'RH2 8HR'
      allow(pcaws_id).to receive(:process).and_return({ status: 'fail_weather', postcode: 'RH2 8HR', temp: nil })
      click_button('Hot, Warm or Cold?')
      expect(page).to have_content("Sorry - we can't get the weather for RH2 8HR right now. Please try again later.")
    end

    it 'says when our api key is not valid' do
      fill_in 'postcode', with: 'RH2 8HR'
      allow(pcaws_id).to receive(:process).and_return({ status: 'fail_no_api', postcode: 'RH2 8HR', temp: nil })
      click_button('Hot, Warm or Cold?')
      expect(page).to have_content("Sorry - we have a fault and can't get the weather for RH2 8HR now. Please try again later.")
    end
  end
end
