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

    desc 'start', 'Start the docker containers'
    def start
      cmd = 'docker compose up -d && docker compose logs --follow --tail --since=15m'
      puts "Will execute#{dry_run? ? ' (Dry-run)' : ''}: #{cmd}" if verbose? || dry_run?

      unless dry_run?
        system(cmd, out: $stdout)
      end
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
      FileUtils.rm_rf(cache_store_path, verbose: verbose?)
      FileUtils.rm_rf(database_path, verbose: verbose?)
    end

    private

    def database_path
      "#{database_root_path}/postgresql/data"
    end

    def cache_store_path
      "#{database_root_path}/redis/data"
    end

    def database_root_path
      Rails.root.join('db', Rails.env)
    end

    def dry_run?
      options[:dry_run]
    end

    def verbose?
      options[:verbose]
    end
  end
end
