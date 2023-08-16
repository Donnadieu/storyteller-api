require 'thor'

module StorySproutCLI
  class Tunnel < Thor
    class_option :verbose,
                 type: :boolean,
                 aliases: '-v',
                 desc: 'Verbose output',
                 default: true, # TODO: Change this to false before shipping
                 required: false
    class_option :dry_run,
                 type: :boolean,
                  aliases: '-d',
                 desc: 'Dry run',
                 default: false,
                 required: false

    namespace :'story-sprout-cli:tunnel'

    def self.exit_on_failure?
      true
    end

    desc 'open_all', 'Open ngrok tunnels for the project'
    def open_all
      project_rel_path = File.expand_path('../../../../', __FILE__)
      if has_realpath_cmd?
        project_root = `realpath "#{project_rel_path}"`
      elsif has_python_3?
        project_root = `python3 -c "import os; print(os.path.realpath('#{project_rel_path}'))"`
      else
        puts 'realpath could not be found. Tunnel will not be opened.'
        exit 1
      end

      if project_root.empty?
        puts 'realpath could not be found. Tunnel will not be opened.'
        exit 1
      end

      project_root.strip!

      if verbose?
        puts <<~CMD
          ===========================================================================
             Project root: #{project_root}
          ===========================================================================
        CMD
      end

      if verbose?
        puts <<~BANNER
          Starting ngrok tunnels for #{project_root}...
        BANNER
      end

      cmd = "ngrok start --all --config=#{ENV.fetch('NGROK_PROFILE_CONFIG_PATH')},#{project_root}/config/ngrok.yml " +
        "--log=stdout > #{project_root}/log/ngrok.log &"

      # cmd = "ngrok start --all --config=#{ENV.fetch('NGROK_PROFILE_CONFIG_PATH')},#{project_root}/config/ngrok.yml " +
      #   "--log=stdout > #{project_root}/log/ngrok.log &"

      if verbose?
        puts <<~CMD
          Will execute: #{cmd}
        CMD
      end

      `#{cmd}` unless dry_run?
    end

    private

    def verbose?
      options[:verbose]
    end

    def dry_run?
      options[:dry_run]
    end

    def has_realpath_cmd?
      @has_realpath_cmd ||= system('command -v realpath')
    end

    def has_python_3?
      @has_python_3 ||= system('command -v python3')
    end
  end
end
