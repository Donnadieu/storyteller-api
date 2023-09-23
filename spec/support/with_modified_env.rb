# frozen_string_literal: true

require 'climate_control'

def with_modified_env(options = {}, &block)
  ClimateControl.modify(options, &block)
end
