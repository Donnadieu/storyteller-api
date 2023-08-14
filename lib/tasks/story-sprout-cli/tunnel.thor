require 'thor'

module StorySproutCLI
  class Tunnel < Thor
    class_option :verbose,
                 type: :boolean,
                 aliases: '-v',
                 desc: 'Verbose output',
                 default: false,
                 required: false

    namespace :'story-sprout-cli:tunnel'

    def self.exit_on_failure?
      true
    end

    desc 'open_all', 'Open ngrok tunnels for the project'
    def open_all
      if has_realpath_cmd?
        project_root = `realpath "#{File.expand_path('..', __FILE__)}"`
      elsif has_python_3?
        project_root = `python3 -c "import os; print(os.path.realpath('#{File.expand_path('..', __FILE__)}'))"`
      else
        puts 'realpath could not be found. Tunnel will not be opened.'
        exit 1
      end

      if project_root.empty?
        puts 'realpath could not be found. Tunnel will not be opened.'
        exit 1
      end

      project_root.strip!

      if options[:verbose]
        puts "Opening ngrok tunnels for #{project_root}"
      end

      # `ngrok start --all --config=#{ENV.fetch('NGROK_PROFILE_CONFIG_PATH')},#{project_root}/config/ngrok.yml ` +
      #   `--log=stdout > #{project_root}/log/ngrok.log &`
      `ngrok start --all --config=#{ENV.fetch('NGROK_PROFILE_CONFIG_PATH')},#{project_root}/config/ngrok.yml`
    end

    private

    def has_realpath_cmd?
      @has_realpath_cmd ||= system('command -v realpath')
    end

    def has_python_3?
      @has_python_3 ||= system('command -v python3')
    end
  end
end
