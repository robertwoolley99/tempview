# frozen_string_literal: true

require 'spec_helper'

include MockApis::PostCodeChecker

RSpec.describe PostCodeCheckerService do
  context 'Correct requests' do
    it 'calls the correct URL' do
      return_successful_check('RH2 8HR')
    end
  end
end
