# frozen_string_literal: true

require 'rails_helper'

load_cli_script 'key_chain'
module StoryCLI
  describe KeyChain do
    describe '#print_keyfile' do
      around do |example|
        with_modified_env(
          HOME: Rails.root.join('spec/fixtures/mock_user_home').to_s
        ) do
          example.run
        end
      end

      it 'prints the contents of the keyfile' do
        expect do
          subject.invoke(:print_keyfile, [], keyfile: '~/Downloads/mock_key_file.json')
        end.to output(/\{\\n\s+\\"name\\":\s+\\"mock-rsa-keypair\\",\\n/).to_stdout
      end

      it 'fails and exits if the keyfile does not exist' do
        expect do
          subject.invoke(:print_keyfile, [], keyfile: '~/nonexistent_keyfile')
        end.to output(/Key file not found/).to_stdout
      end
    end
  end
end
