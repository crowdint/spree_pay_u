require 'spec_helper'

describe Spree::PayU::Response do
  context 'When error response' do
    subject { described_class.new 'code' => 'ERROR', 'error' => 'an error' }

    specify { expect(subject.success?).to be_false }

    specify { expect(subject.message).to eq('an error') }

    specify { expect(subject.params).to eq(message: 'an error', response_reason_text: 'an error') }
  end

  context 'When successful response and approved transaction' do
    subject { described_class.new 'code' => 'SUCCESS', 'transactionResponse' => { 'state' => 'APPROVED' } }

    specify { expect(subject.success?).to be_true }
  end

  context 'When successful response and declined transaction' do
    subject { described_class.new 'code' => 'SUCCESS', 'transactionResponse' => { 'state' => 'DECLINED' } }

    specify { expect(subject.success?).to be_false }
  end
end