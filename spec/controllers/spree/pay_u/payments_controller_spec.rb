require 'spec_helper'

describe Spree::PayU::PaymentsController do
  routes { Spree::Core::Engine.routes }

  describe 'POST :create' do
    let(:payment) { create(:payment, state: 'pending') }

    context 'Payment approved' do
      before do
        Spree::Payment.should_receive(:find_by_identifier).with('bar').and_return payment
        post :create, response_code_pol: 1, reference_sale: 'foo-bar'
      end

      it 'should capture the payment' do
        expect(payment).to be_completed
      end

      it 'should send a completed email' do
        expect(Spree::BaseMailer.deliveries.last.subject).to eq 'The transaction was approved'
      end
    end

    context 'Payment rejected' do
      before do
        Spree::Payment.should_receive(:find_by_identifier).with('bar').and_return payment
        post :create, response_code_pol: 2, reference_sale: 'foo-bar', response_message_pol: 'DECLINED'
      end
      it 'should mark the payment as failed' do
        expect(payment).to be_failed
      end

      it 'should send a rejected payment email' do
        expect(Spree::BaseMailer.deliveries.last.subject).to eq 'The transaction was declined'
      end
    end
  end
end
