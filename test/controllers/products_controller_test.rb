require "test_helper"

describe ProductsController do
  describe 'guest user' do
    describe 'index' do
      it 'succeeds with multiple products for a guest user' do
          Product.count.must_be :>, 0

          get products_path
          must_respond_with :success
      end

      it 'succeeds with no products for a guest user' do
        Product.destroy_all

        Product.count.must_equal 0
        get products_path
        must_respond_with :success
      end
    end

    describe 'show' do
      it 'succeeds for an existing product' do
        product_id = Product.first.id

        get product_path(product_id)

        must_respond_with :success
      end

      it 'renders not_found for a non-existing id' do
        product_id = Product.last.id + 1

        get product_path(product_id)

        must_respond_with :not_found
      end
    end
  end



# TODO update all to have signed in user
  describe 'authenticated user' do
    describe 'create' do
      let (:product_data) {
        {
          name: 'Product',
          stock: 3,
          price: 3.00,
          merchant_id: Merchant.first.id
        }
      }

      it "creates a work with valid data for a real category for an authenticated user" do
        old_product_count = Product.count

        post merchant_products_path(Merchant.first.id), params: { product: product_data }

        must_redirect_to merchant_products_path(Merchant.first.id)
        Product.count.must_equal old_product_count + 1
      end

      it "renders bad_request and does not update the DB for bogus data for an authenticated user" do
        product_data[:name] = nil

        old_product_count = Product.count

        post merchant_products_path(Merchant.first.id), params: { product: product_data }

        must_respond_with :bad_request
        Product.count.must_equal old_product_count
      end
    end

    describe 'new' do
      it 'succeeds for an authenticated user' do
        get new_merchant_product_path(Merchant.first.id)

        must_respond_with :success
      end
    end

    describe 'edit' do
      it 'succeeds for an authenticated user'
    end

    describe 'update' do
      let (:merchant) { Merchant.first }
      let (:product) { Product.first }
      let (:old_product_count) { Product.count }

      it 'succeeds with good data' do
        old_product_stock = product.stock

        product_data = {
          name: product.name,
          stock: product.stock - 1,
          price: product.price,
          merchant_id: product.merchant_id
        }

        patch merchant_product_path(product.merchant.id, product.id), params: { product: product_data }
        product.reload

        must_redirect_to merchant_products_path
        Product.count.must_equal old_product_count

        product.stock.must_equal (old_product_stock - 1)
      end
    end


  end
end
