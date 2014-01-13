require 'spec_helper'

describe Spree::PayU::Provider do
  let(:client) { double('pay_u_client') }

  before do
    subject.stub client: client
  end

  describe '#actions' do
    specify { expect(subject.actions).to eq(%w(purchase)) }
  end

  describe '#purchase' do
    let(:source) { double('source', class: 'foo') }
    let(:response) { { 'code' => 'SUCCESS', 'transactionResponse' => {} } }

    before do
      options = { amount: 10, source: source, gateway_options: {} }
      client.should_receive(:request).with('foo', options).and_return response
    end

    it 'returns a pay u response' do
      expect(subject.purchase(1000, source)).to be_a_kind_of(Spree::PayU::Response)
    end

  end
end