# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Benefit, type: :model do
  describe 'fields which should be enums' do
    it { should define_enum_for(:benefit) }
  end
end
