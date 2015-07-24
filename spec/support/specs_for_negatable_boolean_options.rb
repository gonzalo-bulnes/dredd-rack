RSpec.shared_examples 'a negatable boolean option' do |option|

  it_behaves_like 'an option', option
  it_behaves_like 'a boolean option', option

  it 'is ended by a bang (!)' do
    expect(option[-1]).to eq '!'
  end
end
