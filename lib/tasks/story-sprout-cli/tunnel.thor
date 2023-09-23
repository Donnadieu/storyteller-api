# frozen_string_literal: true

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
      if auth_token_nil?
        puts <<~ERROR
          No ngrok auth token found. Please set NGROK_AUTH_TOKEN in your environment.#{' '}
          You will need an ngrok account to use this CLI command.#{' '}
          See https://dashboard.ngrok.com/get-started/your-authtoken for more information.
        ERROR

        return
      end

      # TODO: Check for ngrok config file(s) and exit if they don't exist
      config_files = []
      app_config_file = File.join(project_root, 'config', 'ngrok.yml')
      profile_config_file = ENV.fetch('NGROK_PROFILE_CONFIG_PATH', nil)
      config_files << profile_config_file if File.exist?(profile_config_file)
      config_files << app_config_file if File.exist?(app_config_file)

      if verbose?
        puts <<~BANNER
          Starting ngrok tunnels for #{project_root}...
        BANNER
      end

      if config_files.empty?
        puts <<~ERROR
          No ngrok config files found. Please create one at #{app_config_file} or #{profile_config_file}.
        ERROR

        exit 1
      end

      cmd = "ngrok start --all --config=#{config_files.join(',')} "

      if verbose?
        puts <<~CMD
          Executing#{dry_run? ? ' (dry-run)' : ''}: #{cmd}
        CMD
      end

      system(cmd, out: $stdout) unless dry_run?
    end

    private

    def auth_token_nil?
      ENV.fetch('NGROK_AUTH_TOKEN', nil).nil?
    end

    def project_root
      return @project_root if @project_root

      project_rel_path = File.expand_path('../../..', __dir__)
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

      @project_root = project_root.strip!

      if verbose?
        puts <<~CMD
          ===========================================================================
             Project root: #{project_root}
          ===========================================================================
        CMD
      end

      @project_root
    end

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
