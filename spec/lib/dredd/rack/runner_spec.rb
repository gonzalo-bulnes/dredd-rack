require 'spec_helper'

describe Dredd::Rack::Runner do

  it 'responds to :api_endpoint', public: true do
    expect(subject).to respond_to :api_endpoint
  end

  it 'responds to :command', public: true do
    expect(subject).to respond_to :command
  end

  it 'responds to :command_parts', private: true do
    expect(subject).to respond_to :command_parts
  end

  it 'responds to :command_parts=', private: true do
    expect(subject).to respond_to :command_parts=
  end

  it 'responds to :configure', public: true do
    expect(subject).to respond_to :configure
  end

  it 'respond_to :paths_to_blueprints', public: true do
    expect(subject).to respond_to :paths_to_blueprints
  end

  it 'responds to :run', public: true do
    expect(subject).to respond_to :run
  end

  it 'generates a valid command by default', public: true do
    expect(subject.send(:command_valid?)).to be_truthy
  end

  describe 'responds to all the Dredd options', public: true do

    Dredd::Rack::Runner::OPTIONS.each do |option|
      it "responds to :#{option}" do
        expect(subject).to respond_to option
      end
    end
  end

  describe 'responds to the negated form of the Dredd boolean options', public: true do

    Dredd::Rack::Runner::NEGATABLE_BOOLEAN_OPTIONS.each do |option|
      it "responds to :no_#{option}" do
        expect(subject).to respond_to "no_#{option}".to_sym
      end
    end
  end

  describe '#api_endpoint', public: true do

    let(:subject) { Dredd::Rack::Runner.new('https://example.com') }

    it 'returns the runner api_endpoint' do
      expect(subject.api_endpoint).to eq 'https://example.com'
    end

    context 'when given an argument' do

      it 'returns the runner api_endpoint' do
        expect(subject.api_endpoint('https://another.example.com')).to eq 'https://another.example.com'
      end

      it 'sets the runner api_endpoint' do
        expect(subject.api_endpoint('https://another.example.com')).to eq 'https://another.example.com'
      end
    end
  end

  describe '#command_valid?', private: true do


    context 'when the command has less than one argument' do

      it 'returns false' do
        allow(subject).to receive_message_chain(:command, :has_at_least_one_argument?).and_return(false)
        allow(subject).to receive_message_chain(:command, :has_at_least_two_arguments?).and_return(false)

        expect(subject.send(:command_valid?)).not_to be_truthy
      end
    end

    context 'when the API to test is remote' do

      before(:each) do
        allow(subject).to receive(:api_remote?).and_return(true)
      end

      context 'when the command has less than two arguments' do

        it 'returns false' do
          allow(subject).to receive_message_chain(:command, :has_at_least_one_argument?).and_return(true)
          allow(subject).to receive_message_chain(:command, :has_at_least_two_arguments?).and_return(false)

          expect(subject.send(:command_valid?)).not_to be_truthy
        end
      end
    end
  end

  describe '#configure', public: true do

    context 'when the generated command has less than two arguments' do

      it 'executes a configration block in the context of the runner' do
        allow(subject).to receive_message_chain(:command, :has_at_least_two_arguments?).and_return(false)

        expect(subject).to receive_message_chain(:dry_run!, :color!)
        expect(subject).to receive(:level).with(:warning)

        subject.configure do |s|
          s.dry_run!.color!
          s.level(:warning)
        end
      end
    end
  end

  describe '#initialize', public: true do

    context 'with an API endpoint as argument' do

      it 'defines a custom API endpoint' do
        expect(Dredd::Rack::Runner.new('https://api.example.com').command).to end_with 'https://api.example.com'
        expect(Dredd::Rack::Runner.new('https://api.example.com').command).not_to match /http:\/\/localhost:3000/
      end
    end

    context 'with a block as argument' do

      it 'returns a configured Dredd runner' do

        subject = Dredd::Rack::Runner.new 'http://localhost:4567' do |options|
          options.paths_to_blueprints 'blueprints/*.apib', 'doc/*.apib'
          options.level :silly
          options.no_color!
        end

        expect(subject.command).to match /http:\/\/localhost:4567/
        expect(subject.command).to match /blueprints\/\*\.apib doc\/\*\.apib/
        expect(subject.command).to match /--level "silly"/
        expect(subject.command).to match /--no-color/

        expect(subject.command).not_to match /http:\/\/localhost:3000/
        expect(subject.command).not_to match /doc\/\*\.apib.md/
      end
    end
  end

  describe '#paths_to_blueprints', public: true do

    it 'is chainable' do
      expect(subject.paths_to_blueprints('some/path/*.apib')).to eq subject
    end


    context 'with one or more paths to blueprints as arguments' do

      it 'defines custom paths to blueprints' do
        expect(subject.paths_to_blueprints('blueprints/*.md', 'blueprints/*.apib').command).to match /blueprints\/\*\.md blueprints\/\*\.apib/
        expect(subject.paths_to_blueprints('blueprints/*.md').command).not_to match /doc/
      end
    end

    context 'with no arguments' do

      it 'raises ArgumentError' do
        expect{ subject.paths_to_blueprints() }.to raise_error ArgumentError, 'invalid path to blueprints'
      end
    end

    context 'with a blank path as argument', public: true do

      it 'raises ArgumentError' do
        expect{ subject.paths_to_blueprints('') }.to raise_error ArgumentError, 'invalid path to blueprints'
      end
    end
  end

  describe '#run', public: true do

    context 'when the command is not valid' do

      before(:each) do
        allow(subject).to receive(:command_valid?).and_return(false)
      end

      it 'raises Dredd::Rack::InvalidCommandError' do
        command = 'test_command'
        allow(subject).to receive(:command).and_return(command)
        expect { subject.run }.to raise_error(Dredd::Rack::InvalidCommandError)
      end
    end

    context 'when the command is valid' do

      before(:each) do
        allow(subject).to receive(:command_valid?).and_return(true)
      end

      it 'runs Dredd!' do
        command = double()
        allow(subject).to receive(:command).and_return(command)

        expect(Kernel).to receive(:system).with(command)
        subject.run
      end

      context 'when configured to test the API locally' do

        before(:each) do
          allow(subject).to receive(:api_remote?).and_return(false)
        end

        context 'with Dredd::Rack.app properly configured' do

          before(:each) do
            @app_under_test = double()
            allow(Dredd::Rack).to receive(:app).and_return(@app_under_test)

            @capybara_server = double()
            allow(@capybara_server).to receive(:new).and_return(@capybara_server)
            allow(@capybara_server).to receive(:host).and_return('localhost')
            allow(@capybara_server).to receive(:port).and_return('4567')
            allow(Kernel).to receive(:system)

            stub_const("Capybara::Server", @capybara_server)
          end

          it 'creates a Capybara::Server instance and serves the API' do
            expect(@capybara_server).to receive(:new).with(@app_under_test)
            expect(@capybara_server).to receive(:boot)
            subject.run
          end

          it 'gets its API endpoint from the Capybara::Server instance' do
            allow(@capybara_server).to receive(:boot)
            expect { subject.run }.to change { subject.api_endpoint }.to("http://#{@capybara_server.host}:#{@capybara_server.port.to_s}")
          end
        end
      end
    end
  end

  Dredd::Rack::Runner::META_OPTIONS.each do |option|
    describe "##{option}", public: true do
      it_behaves_like 'a boolean option', option, ['some argument']
    end
  end

  Dredd::Rack::Runner::NEGATABLE_BOOLEAN_OPTIONS.each do |option|
    describe "##{option}", public: true do
      it_behaves_like 'a negatable boolean option', option.to_sym, ['some argument']
    end

    describe "#no_#{option}", public: true do
      it_behaves_like 'a negatable boolean option', "no_#{option}".to_sym, ['some argument']
    end
  end

  Dredd::Rack::Runner::SINGLE_ARGUMENT_OPTIONS.each do |option|
    describe "##{option}", public: true do
      it_behaves_like 'a single-argument option', option, ['first argument', 'second argument']
    end
  end
end

describe String, public: true do

  it 'responds to :has_at_least_one_argument?' do
    expect(subject).to respond_to :has_at_least_one_argument?
  end

  it 'responds to :has_at_least_two_arguments?' do
    expect(subject).to respond_to :has_at_least_two_arguments?
  end

  it 'responds to :quote!' do
    expect(subject).to respond_to :quote!
  end

  describe '#has_at_least_one_argument?' do

    context 'when the String can be interpreted as a command with at least one argument' do
      context 'returns true (reliable)' do

        ['dredd doc/*.apib',
         'dredd doc/*.apib doc/*apib.md',
         'dredd doc/*.apib --level verbose'].each do |subject|

          it "e.g. '#{subject}'" do
            expect(subject.has_at_least_one_argument?).to be_truthy
          end
        end
      end
    end

    context 'when the String can be interpreted as a command with no arguments' do
      context 'returns false (unreliable)' do

        ['dredd',
         'dredd --dry-run',
         'dredd --dry-run --level verbose'].each do |subject|

          it "e.g. '#{subject}'" do
            expect(subject.has_at_least_one_argument?).to be_falsey
          end
        end
      end
    end
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

  describe '#quote!' do

    let(:string) { "some string" }

    it 'returns the string content surrounded by quotes' do
      expect(string.quote!).to match /some string/
      expect(string.quote!).to match /^".*"$/
    end
  end
end
