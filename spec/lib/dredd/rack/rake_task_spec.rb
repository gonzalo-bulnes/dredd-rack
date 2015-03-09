require 'spec_helper'

describe Dredd::Rack::RakeTask do

  it 'is a kind of Rake::TaskLib', protected: true do
    expect(subject).to be_kind_of ::Rake::TaskLib
  end

  it 'responds to :description', public: true do
    expect(subject).to respond_to :description
  end

  it 'responds to :dredd_runner', public: true do
    expect(subject).to respond_to :dredd_runner
  end

  it 'responds to :name', public: true do
    expect(subject).to respond_to :name
  end

  describe '#dredd_runner', public: true do

    it 'is a default Dredd runner' do
      expect(subject.dredd_runner).to be_kind_of Dredd::Rack::Runner
      expect(subject.dredd_runner.command).to match(/\Adredd doc\/\*\.apib doc\/\*\.apib\.md http:\/\/localhost:3000\z/)
    end
  end

  describe '#description', public: true do

    it 'defaults to "Run Dredd::Rack API blueprint verification"' do
      expect(subject.description).to eq 'Run Dredd::Rack API blueprint verification'
    end

    context 'when a custom name was provided' do

      context 'and a custom description was provided' do

        it 'return the custom description' do
          subject = Dredd::Rack::RakeTask.new(:dredd, 'Validate an API against its blueprint')
          expect(subject.description).to eq 'Validate an API against its blueprint'
        end
      end
    end
  end

  describe '#name', public: true do

    it 'defaults to :dredd' do
      expect(subject.name).to eq :dredd
    end

    context 'when a custom name was provided' do

      it 'returns the custom name' do
        subject = Dredd::Rack::RakeTask.new(:anderson)
        expect(subject.name).to eq :anderson
      end
    end
  end

  context 'when invoked' do

    before(:each) do
      pending "I don't know how to stub `$?` so I can run `Rake::Task[subject.name].invoke`"
      #allow($?).to receive(:exitstatus).and_return(0) # breaks the test suite
    end

    it 'runs Dredd', public: true do
      expect(Kernel).to receive(:system).with(subject.dredd_runner.command)
      #Rake::Task[subject.name].invoke
    end

    context 'when Dredd is not available' do

      it 'exits with status 127', public: true do
        subject = Dredd::Rack::RakeTask.new(nil, nil, 'http://unresponsive')

        expect(Kernel).to receive(:exit).with(127)
        #Rake::Task[subject.name].invoke
      end

      it 'outputs a failure message', public: true do
        subject = Dredd::Rack::RakeTask.new(nil, nil, 'http://unresponsive')
        message = double()
        # TODO: define output

        expect(subject).to receive(:failure_message).with(127).and_return(message)
        expect(output).to receive(:puts).with(message)

        #Rake::Task[subject.name].invoke
      end
    end

    context 'with an unresponsive API' do

      it 'exits with status 8', public: true do
        subject = Dredd::Rack::RakeTask.new(nil, nil, 'http://unresponsive')

        expect(Kernel).to receive(:exit).with(8)
        #Rake::Task[subject.name].invoke
      end

      it 'outputs a failure message', public: true do
        subject = Dredd::Rack::RakeTask.new(nil, nil, 'http://unresponsive')
        message = double()
        # TODO: define output

        expect(subject).to receive(:failure_message).with(8).and_return(message)
        expect(output).to receive(:puts).with(message)

        #Rake::Task[subject.name].invoke
      end
    end
  end
end
