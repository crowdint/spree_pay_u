require 'spec_helper'

describe Spree::PayU::Client do
  describe '#test?' do
    context 'when test' do
      subject { described_class.new test_mode: true }

      specify { expect(subject.test?).to be_true }
    end

    context 'when not test' do
      subject { described_class.new test_mode: false }

      specify { expect(subject.test?).to be_false }
    end
  end

  describe '#server' do
    context 'When test' do
      subject { described_class.new test_mode: true, staging_server: 'staging', production_server: 'production' }

      it 'should be the staging server' do
        expect(subject.server).to eq('staging')
      end
    end

    context 'When not test' do
      subject { described_class.new test_mode: false, staging_server: 'staging', production_server: 'production' }

      it 'should be the production server' do
        expect(subject.server).to eq('production')
      end
    end
  end

  describe '#connection' do
    let(:headers) { { 'Accept' => 'application/json', 'Content-type' => 'application/xml' } }

    subject { described_class.new test_mode: true, staging_server: 'staging', production_server: 'production' }

    before do
      @connection = subject.connection
    end

    it 'it should be a faraday connection' do
      expect(@connection).to be_a_kind_of(Faraday::Connection)
    end

    specify { expect(@connection.headers['Accept']).to eq(headers['Accept']) }

    specify { expect(@connection.headers['Content-type']).to eq(headers['Content-type']) }
  end
end
