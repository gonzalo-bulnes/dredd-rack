require 'spec_helper'

describe 'Dredd::Rack::Runner' do

  describe '.run' do

    context 'with no arguments' do

      it 'raises an error' do
        expect{ Dredd::Rack::Runner.run }.to raise_error ArgumentError
      end
    end

    context 'with one argument' do

      it 'loads the blueprints from the default path' do
        allow(Dredd::Rack::Runner).to receive_message_chain(:configuration, :default_path_to_blueprints)
                                      .and_return('/blueprints/path/*.apib')

        expect(Dredd::Rack::Runner.run 'http://api.example.com').to eq 'dredd /blueprints/path/*.apib http://api.example.com'
      end
    end

    context 'with several arguments' do

      it 'calls Dredd with them' do
        expect(Dredd::Rack::Runner.run '/some/path', 'another/path/', 'http://api.example.com').to \
                                       eq 'dredd /some/path another/path/ http://api.example.com'
      end
    end

    context 'when given a block of options' do

      it 'calls Dredd with them' do
        subject = Dredd::Rack::Runner.run('*.apib', 'http://api.example.com') do |options|
          options.dry_run
        end
        expect(subject).to eq 'dredd *.apib http://api.example.com --dry-run'
      end
    end
  end
end
