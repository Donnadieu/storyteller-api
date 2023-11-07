# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestrictedIpsConstraint do
  let(:mock_request) { instance_double(ActionDispatch::Request) }

  before do
    allow(mock_request).to receive(:forwarded_for) { nil }
  end

  subject { described_class.new }

  describe '#matches?' do
    shared_examples 'a service with an allowed list of IP addresses' do |ip_address_csv_list, mock_remote_ip|
      before do
        allow(mock_request).to receive(:remote_ip) { mock_remote_ip }
      end

      around do |example|
        with_modified_env ADMIN_REMOTE_IP_ADDRESSES: ip_address_csv_list do
          example.run
        end
      end

      it 'succeeds when the request is from an allowed IP' do
        allow(mock_request).to receive(:remote_ip) { mock_remote_ip }
        expect(subject.matches?(mock_request)).to eq(true)
      end

      it 'fails when the request is not from an allowed IP' do
        allow(mock_request).to receive(:remote_ip) { '1.2.3.4' }
        expect(subject.matches?(mock_request)).to eq(false)
      end
    end

    context 'when the ADMIN_REMOTE_IP_ADDRESSES environment variable is set' do
      it_should_behave_like 'a service with an allowed list of IP addresses',
                            '8.8.8.8,34.218.67.123,4.4.4.4', '34.218.67.123'
    end

    context 'when the ADMIN_REMOTE_IP_ADDRESSES environment variable is set to a single IP address' do
      it_should_behave_like 'a service with an allowed list of IP addresses',
                            '34.218.67.123', '34.218.67.123'
    end

    context 'when the ADMIN_REMOTE_IP_ADDRESSES environment variable is not set' do
      around do |example|
        with_modified_env ADMIN_REMOTE_IP_ADDRESSES: nil do
          example.run
        end
      end

      it 'fails when the request is not from an allowed IP' do
        allow(mock_request).to receive(:remote_ip) { '1.2.3.4' }
        expect(subject.matches?(mock_request)).to eq(false)
      end
    end
  end
end
