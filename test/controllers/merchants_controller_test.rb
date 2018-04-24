require "test_helper"

describe MerchantsController do
  describe 'authenticated user' do
    before do
      @merchant = Merchant.first
      login(@merchant)
    end
    describe 'index' do
      it 'returns success with many mearchants' do
        get merchants_path

        must_respond_with :success
      end

      it 'returns success with no merchants' do
        Merchant.destroy_all

        get merchants_path

        must_respond_with :success
      end
    end

    describe 'show' do
      it 'returns success' do
        merchant2 = Merchant.last
        get merchant_path(merchant2.id)

        must_respond_with :success
      end
    end
  end

  describe 'guest user' do
    describe 'index' do
      it 'returns success with many mearchants' do
        get merchants_path

        must_respond_with :success
      end

      it 'returns success with no merchants' do
        Merchant.destroy_all

        get merchants_path

        must_respond_with :success
      end
    end

    describe 'show' do
      it 'returns success' do
        merchant2 = Merchant.last
        get merchant_path(merchant2.id)

        must_respond_with :success
      end
    end
  end
end
