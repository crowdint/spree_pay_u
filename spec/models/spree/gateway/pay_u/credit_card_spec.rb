require 'spec_helper'

describe Spree::Gateway::PayU::CreditCard do
  describe '#provider_class' do
    specify { expect(subject.provider_class).to eq(Spree::PayU::Provider) }
  end

  describe 'auto_capture?' do
    specify { expect(subject.auto_capture?).to be_false }
  end

  describe '#method_type' do
    specify { expect(subject.method_type).to eq('pay_u_credit_card') }
  end
end
