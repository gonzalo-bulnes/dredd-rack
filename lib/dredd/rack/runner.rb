module Dredd
  module Rack
    class Runner

      def run(paths_to_blueprints, api_endpoint, options={})
        command = 'dredd'
        command << ' ' + paths_to_blueprints.join(' ') unless paths_to_blueprints.empty?
        command << ' ' + api_endpoint

        options.each do |key, value|
          flag = "#{value == false ? '--no-' : '--'}#{key.to_s.gsub('_', '-')}"
          if value == true || value == false
            command << ' ' + flag
          elsif value.respond_to?(:each)
            value.each do |value_element|
              command << ' ' + flag
              command << ' ' + "\'" + value_element.to_s + "\'"
            end
          else
            command << ' ' + flag
            command << ' ' + value.to_s
          end
        end
        system(command)
      end
    end
  end
end
