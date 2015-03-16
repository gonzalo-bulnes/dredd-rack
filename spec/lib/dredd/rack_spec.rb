require 'spec_helper'

describe Dredd::Rack do

  it 'is configurable', public: true do
    expect(subject).to be_kind_of Dredd::Rack::Configuration
  end
end
