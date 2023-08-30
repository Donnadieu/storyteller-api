require 'rails_helper'

load Rails.root.join('lib/tasks/story-sprout-cli/tunnel.thor')

module StorySproutCLI
  describe Tunnel, type: :task, devtool: true do
    subject { described_class.new }

    describe '#open_all' do
      around do |example|
        with_modified_env(
          NGROK_PROFILE_CONFIG_PATH: Rails.root.join('spec/fixtures/mock_user_home/.ngrok2/ngrok.yml').to_s
        ) do
          example.run
        end
      end

      it 'successfully opens the tunnel' do
        with_modified_env(NGROK_AUTH_TOKEN: 'mock-auth-token') do
          expect {
            subject.invoke(:open_all, [], verbose: true, dry_run: true)
          }.to output(/\(dry-run\): ngrok start --all/).to_stdout
        end
      end

      it 'fails and exits if the NGROK_AUTH_TOKEN is not set' do
        with_modified_env(NGROK_AUTH_TOKEN: nil) do
          expect {
            subject.invoke(:open_all, [], verbose: true, dry_run: true)
          }.to output(/No ngrok auth token found/).to_stdout
        end
      end
    end

    describe '#has_realpath_cmd?' do
      context 'actual test on this system' do
        let(:expected_shell_output) { `command -v realpath`.chomp }

        it 'returns true|false depending on whether command file exists' do
          expect(subject.send(:has_realpath_cmd?)).to be { File.exists? expected_shell_output }
        end
      end
    end

    describe '#has_python_3?' do
      context 'actual test on this system' do
        let(:expected_shell_output) { `command -v python3`.chomp }

        it 'returns true|false depending on whether command file exists' do
          expect(subject.send(:has_python_3?)).to be { File.exists? expected_shell_output }
        end
      end
    end
  end
end
