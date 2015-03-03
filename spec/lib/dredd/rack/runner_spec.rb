require 'spec_helper'

describe Dredd::Rack::Runner do

  it 'responds to :command', public: true do
    expect(subject).to respond_to :command
  end

  it 'responds to :command_parts', private: true do
    expect(subject).to respond_to :command_parts
  end

  it 'responds to :command_parts=', private: true do
    expect(subject).to respond_to :command_parts=
  end

  describe 'responds to all the Dredd options', public: true do

    Dredd::Rack::Runner::OPTIONS.each do |option|
      it "responds to :#{option}" do
        expect(subject).to respond_to option
      end
    end
  end

  describe '#command', public: true do

    it 'defaults to "dredd"' do
      expect(subject.command).to eq 'dredd'
    end
  end

  Dredd::Rack::Runner::BOOLEAN_OPTIONS.each do |option|
    describe "##{option}", public: true do
      it_behaves_like 'a boolean option', option, ['some argument']
    end
  end

  Dredd::Rack::Runner::SINGLE_ARGUMENT_OPTIONS.each do |option|
    describe "##{option}", public: true do
      it_behaves_like 'a single-argument option', option, ['first argument', 'second argument']
    end
  end
end
