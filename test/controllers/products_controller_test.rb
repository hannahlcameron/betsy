require "test_helper"

describe ProductsController do
  describe 'index' do
    it 'succeeds with multiple products' do
        Product.count.must_be :>, 0

        get products_path
        must_respond_with :success
    end

    it 'succeeds with no products' do
      Product.destroy_all

      Product.count.must_equal 0
      get products_path
      must_respond_with :success
    end

    it "it can show only one merchant's products" do

    end
  end

  describe 'new' do
    it 'succeeds' do
      get new_merchant_product_path(Merchant.first.id)

      must_respond_with :success
    end
  end

  describe 'create' do
    it "creates a work with valid data for a real category" do
      product_data = {
        name: 'Product',
        stock: 3,
        price: 3.00,
        merchant_id: Merchant.first.id
      }

      old_product_count = Product.count

      post merchant_products_path(Merchant.first.id), params: { product: product_data }

      must_redirect_to merchant_products_path(Merchant.first.id)
      Product.count.must_equal old_product_count + 1

    end

    it "renders bad_request and does not update the DB for bogus data" do
    end

  end

end
