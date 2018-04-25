require "test_helper"

describe SessionsController do
  describe 'auth_callback' do
    it 'logs in an existing user' do
      merchant = Merchant.first

      login(merchant)

      must_redirect_to orders_path
      session[:merchant_id].must_equal merchant.id
    end

    it 'creates a new merchant if one does not already exist' do
      merchant_data = {
        username: 'Test User',
        email: 'test@email.com',
        uid: '9999999999999',
        provider: 'google_oauth2'
      }

      merchant = Merchant.new(merchant_data)
      merchant.valid?.must_equal true

      old_merchant_count = Merchant.count

      login(merchant)
      must_redirect_to orders_path

      Merchant.count.must_equal old_merchant_count + 1
      session[:merchant_id].must_equal Merchant.last.id
    end
  end
end
