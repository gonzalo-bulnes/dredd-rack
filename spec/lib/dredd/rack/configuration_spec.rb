require 'spec_helper'

describe Dredd::Rack::Configuration do

  context 'when extending any class' do

    before(:each) do
      Dredd::Rack.const_set(:ConfigurableClass, Class.new)
      @klass = Dredd::Rack::ConfigurableClass
      @klass.send :extend, Dredd::Rack::Configuration
    end

    after(:each) do
      Dredd::Rack.send(:remove_const, :ConfigurableClass)
    end

    let(:subject) { @klass }

    describe 'provides .app which' do

      it_behaves_like 'a configuration option', 'app'

      it "defauts to nil", private: true do
        expect(subject.app).to be_nil
      end
    end

    describe 'provides .dredd_command which' do

      it_behaves_like 'a configuration option', 'dredd_command'

      it "defauts to 'dredd'", private: true do
        expect(subject.dredd_command).to eq 'dredd'
      end
    end
  end
end
