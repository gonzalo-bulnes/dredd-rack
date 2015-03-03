RSpec.shared_examples 'an option' do |option|

  it 'is chainable' do
    expect(subject.send(option)).to eq subject
  end
end
