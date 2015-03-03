require 'spec_helper'

describe Dredd::Rack::Runner do

  describe '#run' do

    describe 'with distinct arguments sets' do

      context 'with the sets of arguments from sample 1' do
        it 'runs Dredd' do
          allow(subject).to receive(:system)
          expect(subject).to receive(:system).with('dredd <path to blueprint> <another path to blueprint> <api_endpoint>')
          subject.run(['<path to blueprint>', '<another path to blueprint>'], '<api_endpoint>')
        end
      end

      context 'with the sets of arguments from sample 2' do
        it 'runs Dredd' do
          allow(subject).to receive(:system)
          expect(subject).to receive(:system).with('dredd <api_endpoint> --dry-run --sorted')
          subject.run([], '<api_endpoint>', dry_run: true, sorted: true)
        end
      end

      context 'with the sets of arguments from sample 3' do
        it 'runs Dredd' do
          allow(subject).to receive(:system)
          expect(subject).to receive(:system).with('dredd <api_endpoint> --dry-run --level info')
          subject.run([], '<api_endpoint>', dry_run: true, level: :info)
        end
      end

      context 'with the sets of arguments from sample 4' do
        it 'runs Dredd' do
          allow(subject).to receive(:system)
          expect(subject).to receive(:system).with('dredd <path to blueprint> <api_endpoint>')
          subject.run(['<path to blueprint>'], '<api_endpoint>')
        end
      end

      context 'with the sets of arguments from sample 5' do
        it 'runs Dredd' do
          allow(subject).to receive(:system)
          expect(subject).to receive(:system).with("dredd <path to blueprint> <api_endpoint> --only 'Machines > Machines collection > Get Machines' --only 'Machine > Get Machines'")
          subject.run(['<path to blueprint>'], '<api_endpoint>', only: ['Machines > Machines collection > Get Machines', 'Machine > Get Machines'])
        end
      end
    end
  end
end
