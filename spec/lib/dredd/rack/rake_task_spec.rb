require 'spec_helper'

describe Dredd::Rack::RakeTask do

  it 'is a kind of Rake::TaskLib', protected: true do
    expect(subject).to be_kind_of ::Rake::TaskLib
  end

  it 'responds to :description', public: true do
    expect(subject).to respond_to :description
  end

  it 'responds to :runner', public: true do
    expect(subject).to respond_to :runner
  end

  it 'responds to :name', public: true do
    expect(subject).to respond_to :name
  end

  context 'when initialized' do

    it 'ensures integration with Rails', protected: true do
      allow_any_instance_of(Dredd::Rack::RakeTask).to receive(:integrate_with_rails!).and_raise 'Integration with Rails was ensured.'
      expect{ Dredd::Rack::RakeTask.new }.to raise_error 'Integration with Rails was ensured.'
    end
  end

  describe '#runner', public: true do

    it 'is a default Dredd::Rack runner' do
      expect(subject.runner).to be_kind_of Dredd::Rack::Runner
      expect(subject.runner.command).to match(/\Adredd doc\/\*\.apib doc\/\*\.apib\.md \z/)
    end
  end

  describe '#description', public: true do

    it 'defaults to "Run Dredd::Rack API blueprint verification"' do
      expect(subject.description).to eq 'Run Dredd::Rack API blueprint verification'
    end

    context 'and a custom description was provided' do

      it 'returns the custom description' do
        pending "I don't know how to setup the custom description."
        # set the custom description here

        subject = Dredd::Rack::RakeTask.new # should be created after setting the description
        expect(subject.description).to eq 'Validate an API against its blueprint'
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

  describe '#integrate_with_rails!', private: true do

    context 'when the :environment Rake task is available' do

      it 'defines it as a prerequisite to load the Rails environment', focus: true do
        allow(Rake::Task).to receive(:task_defined?).with(:environment).and_return(true)

        rake_task = double
        expect(rake_task).to receive(:enhance).with([:environment])
        subject.send(:integrate_with_rails!, rake_task)
      end
    end
  end
end
