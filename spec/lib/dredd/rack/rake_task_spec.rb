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
end
