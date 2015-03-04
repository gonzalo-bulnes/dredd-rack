require 'spec_helper'

describe Dredd::Rack::Runner do

  it 'responds to :command' do
    expect(subject).to respond_to :command
  end

  it 'responds to :command_parts', private: true do
    expect(subject).to respond_to :command_parts
  end

  it 'responds to :command_parts=', private: true do
    expect(subject).to respond_to :command_parts=
  end

  it 'responds to :run'

  it 'responds to :valid?'

  describe 'responds to all the Dredd options' do

    Dredd::Rack::Runner::OPTIONS.each do |option|
      it "responds to :#{option}" do
        expect(subject).to respond_to option
      end
    end
  end

  describe 'responds to the negated form of the Dredd boolean options' do

    Dredd::Rack::Runner::BOOLEAN_OPTIONS.each do |option|
      it "responds to :no_#{option}"
    end
  end

  describe '#command' do

    it 'defaults to "dredd"' do
      expect(subject.command).to eq 'dredd'
    end
  end

  describe '#initialize' do
    it 'emits a warning if essential arguments are missing'
    it 'enforces a default path to blueprints'
  end

  describe '#run' do
    it 'runs Dredd!'
  end

  describe '#valid?' do
    it 'requires at least a path to blueprints and an API endpoint'
  end

  Dredd::Rack::Runner::BOOLEAN_OPTIONS.each do |option|
    describe "##{option}" do
      it_behaves_like 'a boolean option', option, ['some argument']
    end
  end

  Dredd::Rack::Runner::SINGLE_ARGUMENT_OPTIONS.each do |option|
    describe "##{option}" do
      it_behaves_like 'a single-argument option', option, ['first argument', 'second argument']
    end
  end
end
