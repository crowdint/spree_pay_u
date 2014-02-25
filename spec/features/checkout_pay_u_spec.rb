require 'spec_helper'

describe 'Checkout with PayU' do
  before do
    Spree::Config[:currency] = 'MXN'
  end

  context 'Credit card' do
    let!(:country) { create(:country, :states_required => true) }
    let!(:state) { create(:state, :country => country) }
    let!(:stock_location) { create(:stock_location) }
    let!(:order) { OrderWalkthrough.up_to(:delivery) }
    let!(:line_item) { order.line_items.last }
    let!(:user) { create(:user) }

    let!(:pay_u_payment_method) do
      Spree::Gateway::PayU::CreditCard.create!(
          name: 'Credit card',
          environment: "test",
          preferred_api_key: '6u39nqhq8ftd0hlvnjfs66eh8c',
          preferred_api_login: '11959c415b33d0c',
          preferred_merchant_id: '500238',
          preferred_account_id: '500537'
      )
    end

    before do
      line_item.price = 100.0
      line_item.save
      order.update_column(:user_id, user.id)
      order.reload.update!
      Spree::StoreController.any_instance.stub(:current_order => order)
      Spree::StoreController.any_instance.stub(:try_spree_current_user => user)
      visit spree.checkout_state_path(:payment)
    end

    specify 'I should be able to pay with credit card', js: true do
      within '#payment' do
        page.should have_content('Credit card')
      end
    end

    specify 'A payment should be successfully made with a valid credit card', js: true do
      VCR.use_cassette('valid_credit_card') do
        within '#payment' do
          choose 'Credit card'
          fill_in 'Card Number', with: '4111111111111111'
          fill_in 'Card Code', with: '123'
        end
        click_button 'Save and Continue'
        page.should have_content("Your order has been processed successfully")
      end
    end

    specify 'A payment should not be processed with an invalid credit card', js: true do
      VCR.use_cassette('invalid_credit_card') do
        within '#payment' do
          choose 'Credit card'
          fill_in 'Card Number', with: '4111111111111111'
          fill_in 'Card Code', with: '13'
        end
        click_button 'Save and Continue'
        page.should have_content("1 error prohibited this record from being saved")
      end
    end
  end
end
