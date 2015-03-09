RSpec.shared_examples 'a single-argument option' do |option, args|

  it_behaves_like 'an option', option

  it 'appends its flag and argument to the command' do
    option_flag = option.to_s.gsub('_', '-').prepend('--')

    expect{ subject.send(option, args.slice(0), args.slice(1)) }.to change{
      subject.command
    }.to(end_with "#{option_flag} \"#{args.slice(0)}\"")
  end
end
