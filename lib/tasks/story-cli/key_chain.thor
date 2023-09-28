# frozen_string_literal: true

require 'thor'

module StoryCLI
  # Manage credentials for the rails app
  class KeyChain < Thor
    class_option :verbose,
                 type: :boolean,
                 aliases: '-v',
                 desc: 'Verbose output',
                 default: true,
                 required: false
    class_option :dry_run,
                 type: :boolean,
                 aliases: '-d',
                 desc: 'Dry run',
                 default: false,
                 required: false
    class_option :environment,
                 type: :string,
                 aliases: '-e',
                 desc: 'Environment',
                 required: false

    namespace :'story-cli:secrets'

    def self.exit_on_failure?
      true
    end

    desc 'edit', 'Manage the secrets in the environment credentials file'
    option :editor,
           type: :string,
           aliases: '-a',
           desc: 'Editor to use',
           default: 'rubymine --wait',
           required: true
    def edit
      executable = Rails.root.join('bin', 'rails')
      command_to_run = "EDITOR=\"#{editor}\" bundle exec #{executable} credentials:edit --environment=#{env}"

      puts "Will execute#{dry_run? ? ' (Dry-run)' : ''}: #{command_to_run}" if verbose? || dry_run?

      return if dry_run?

      system(command_to_run, out: $stdout)
    end

    private

    def rubymine?
      system('which rubymine')
    end

    def vscode?
      system('which code')
    end

    def dry_run?
      options[:dry_run]
    end

    def verbose?
      options[:verbose]
    end

    def env
      return @env if @env.present?

      if options[:environment].present?
        puts <<~WARNING
          WARNING: You are overriding the environment with "#{options[:environment]}", so#{' '}
            the contents of the credentials file may not match the environment you are expecting.
            When you close the file, the contents will be written to:
            #{credentials_file}
        WARNING

        return options[:environment]
      end

      @env = options[:environment] || Rails.env
    end

    def credentials_file
      Rails.root.join('config', 'credentials', "#{options[:environment]}.yml.enc")
    end

    def editor
      return @editor if @editor.present?

      @editor = ENV.fetch('EDITOR', options[:editor])
      @editor ||= 'rubymine --wait' if rubymine?
      @editor ||= 'code --wait' if vscode?

      @editor ||= 'nano --wait'
    end
  end
end
