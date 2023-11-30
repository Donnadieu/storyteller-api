# frozen_string_literal: true

require 'thor'
require 'fileutils'

module StoryCLI
  class Docker < Thor
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

    namespace :'story-cli:docker'

    def self.exit_on_failure?
      true
    end

    desc 'setup', 'Setup the docker (development) environment'
    def setup
      %w[DATABASE_USER DATABASE_PASSWORD].each do |key|
        abort "Please set the #{key} environment variable" unless ENV.key?(key)
      end

      # Create the secrets directory if it doesn't exist
      FileUtils.mkdir_p(secrets_path, verbose: verbose?)

      # Save the database user to a local file for use by the docker-compose.yml config file
      if File.exist? database_user_path
        puts "Database user already exists at #{database_user_path}"
      else
        File.open(database_user_path, 'w') { |f| f.puts(ENV.fetch('DATABASE_USER')) }
      end

      # Save the database password to a local file for use by the docker-compose.yml config file
      if File.exist? database_password_path
        puts "Database password already exists at #{database_password_path}"
      else
        File.open(database_password_path, 'w') { |f| f.puts(ENV.fetch('DATABASE_PASSWORD')) }
      end
    end

    desc 'start', 'Start the docker containers'
    def start
      setup unless dry_run? || File.exist?(database_user_path)
      cmd = 'docker compose up -d && docker compose logs --follow --tail --since=15m'
      puts "Will execute#{dry_run? ? ' (Dry-run)' : ''}: #{cmd}" if verbose? || dry_run?

      return if dry_run?

      system(cmd, out: $stdout)
    end

    desc 'clean', 'Clean up docker files, volumes, images and containers'
    def clean
      puts <<~HEREDOC
        This will remove all docker files, containers and networks.
        This will also remove all local database files.
      HEREDOC
      cmd = 'docker compose down'
      puts "Will execute#{dry_run? ? ' (Dry-run)' : ''}: #{cmd}" if verbose? || dry_run?

      return if dry_run?

      system(cmd, out: $stdout)
      FileUtils.rm_rf(database_path, verbose: verbose?)
    end

    private

    def secrets_path
      Rails.root.join('config', 'secrets').to_s
    end

    def database_user_path
      "#{secrets_path}/database-user.txt"
    end

    def database_password_path
      "#{secrets_path}/database-password.txt"
    end

    def database_path
      Rails.root.join('db', ENV.fetch('RAILS_ENV', 'development'), 'postgresql', 'data').to_s
    end

    def dry_run?
      options[:dry_run]
    end

    def verbose?
      options[:verbose]
    end
  end
end
