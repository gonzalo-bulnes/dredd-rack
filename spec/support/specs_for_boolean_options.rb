RSpec.shared_examples 'a boolean option' do |option|

  it_behaves_like 'an option', option

  it 'appends its flag to the command' do
    option_flag = option.to_s.gsub('_', '-').prepend('--')

    expect{ subject.send(option) }.to change{
      subject.command
    }.to(include "#{option_flag}")
  end

  it 'ignores any option argument' do
    option_flag = option.to_s.gsub('_', '-').prepend('--')

    expect{ subject.send(option, 'first argument', 'second argument') }.to change{
      subject.command
    }.to(end_with "#{option_flag}")
  end
end
