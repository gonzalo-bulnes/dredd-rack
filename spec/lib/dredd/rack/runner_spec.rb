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

  it 'responds to :run' do
    expect(subject).to respond_to :run
  end

  it 'responds to :valid?' do
    expect(subject).to respond_to :valid?
  end

  it 'generates a valid command by default' do
    expect(subject).to be_valid
  end

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

    it 'defaults to "dredd doc/*apib doc/*.apib.md http://localhost:3000"' do
      expect(subject.command).to eq 'dredd doc/*.apib doc/*.apib.md http://localhost:3000'
    end
  end

  describe '#initialize' do
    it 'emits a warning if essential arguments are missing'
    it 'enforces a default path to blueprints'
  end

  describe '#run' do

    context 'when the command is valid' do

      it 'runs Dredd!' do
        command = double()
        allow(subject).to receive(:command).and_return(command)
        allow(command).to receive(:valid?).and_return(true)

        expect(Kernel).to receive(:system).with(command)
        subject.run
      end
    end
  end

  describe '#valid?' do

    context 'when the generated command has less than two arguments' do

      it 'returns false' do
        allow(subject).to receive_message_chain(:command, :has_at_least_two_arguments?).and_return(false)
        expect(subject).not_to be_valid
      end
    end
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

describe String do

  it 'responds to :has_at_least_two_arguments?' do
    expect(subject).to respond_to :has_at_least_two_arguments?
  end


  describe '#has_at_least_two_arguments?' do

    context 'when the String can be interpreted as a command with at least two arguments' do
      context 'returns true (reliable)' do

        ['dredd doc/*.apib http://api.example.com',
         'dredd doc/*.apib doc/*apib.md http://api.example.com',
         'dredd doc/*.apib http://api.example.com --level verbose'].each do |subject|

          it "e.g. '#{subject}'" do
            expect(subject.has_at_least_two_arguments?).to be_truthy
          end
        end
      end
    end

    context 'when the String can be interpreted as a command with less than two arguments' do
      context 'returns false (unreliable)' do

        ['dredd http://api.example.com',
         'dredd doc/*.apib --dry-run',
         'dredd --dry-run --level verbose'].each do |subject|

          it "e.g. '#{subject}'" do
            expect(subject.has_at_least_two_arguments?).to be_falsey
          end
        end
      end
    end
  end
end
