require 'spec_helper'

shared_examples_for 'pay_u_request' do
  let(:connection) { double('connection') }
  let(:source) { double('source') }

  let(:options) do
    {
      test_mode: true,
      language: 'es',
      api_login: 'foo',
      api_key: 'bar',
      merchant_id: 'mer123',
      amount: 10,
      account_id: 'account123'
    }
  end

  let(:gateway_options) do
    {
      order_id: 'order123',
      currency: 'MXN'
    }
  end

  before do
    options.merge! gateway_options: gateway_options, source: source
  end

  subject { described_class.new(connection, options) }

  describe '#test_mode' do
    context 'When test' do
      specify { expect(subject.test?).to be_true }
    end

    context 'When not test' do
      before do
        options[:test_mode] = false
      end

      specify { expect(subject.test?).to be_false }
    end
  end

  describe '#payload' do
    before do
      subject.should_receive(:common_payload).and_return foo: 'bar'
      subject.should_receive(:transaction).and_return transaction: {}
    end

    it 'is a xml payload mode of the common payload and the transaction definition' do
      expect(subject.payload).to eq("<request>\n  <foo>bar</foo>\n  <transaction>\n  </transaction>\n</request>\n")
    end
  end

  describe '#create' do
    let(:response) { double('pay_u_response', body: '{ "foo": "bar" }') }

    before do
      subject.stub payload: '<request></request>'
      connection.should_receive(:post).
          with('/payments-api/4.0/service.cgi','<request></request>').
          and_return response
    end

    it 'create a request to Pay U' do
      expect(subject.create).to eq({ 'foo' => 'bar' })
    end
  end

  describe '#common_payload' do
    specify do
      payload = {
        language: 'es',
        command:  'SUBMIT_TRANSACTION',
        isTest:   true,
        merchant:  {
            apiLogin: 'foo',
            apiKey: 'bar'
        }
      }
      expect(subject.common_payload).to eq(payload)
    end
  end

  describe '#signature' do
    it 'encodes a string in the format specified by pay u to md5' do
      signature = Digest::MD5.hexdigest('bar~mer123~order123~10~MXN')
      expect(subject.signature).to eq(signature)
    end
  end

  describe '#order' do
    before do
      subject.stub signature: '123'
      subject.stub additional_values: {}
    end

    specify do
      expected_order = {
          referenceCode: 'order123',
          description: 'spree order',
          language: 'es',
          signature: '123',
          additionalValues: {},
          accountId: 'account123',
          buyer: ''
      }

      expect(subject.order).to eq(expected_order)
    end
  end

  describe '#additional_values' do
    specify do
      expected_additional_values = {
        entry: {
          string: 'TX_VALUE',
          additionalValue: {
            value: 10,
            currency: 'MXN'
          }
        }
      }

      expect(subject.additional_values).to eq(expected_additional_values)
    end
  end
end

