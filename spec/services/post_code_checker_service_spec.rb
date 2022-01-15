# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PostCodeCheckerService do
  include MockApis::PostCodeChecker
  context 'Correct requests' do
    it 'calls the correct URL' do
      return_successful_check('RH2 8HR')
    end
  end
end