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

      it 'succeeds for a specific category' do
        category = Category.first

        get category_path(category.name)
        must_respond_with :success
      end

      it 'succeeds with no categories' do
        Category.destroy_all

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

  describe 'authenticated user' do
    let (:product_data) {
      {
        name: 'Product',
        stock: 3,
        price: 3.00,
        merchant_id: Merchant.first.id
      }
    }
    let(:merchant) { Merchant.first }

    before do
      login(merchant)
    end

    describe 'index' do
      it 'works with no products' do
        Product.where(merchant_id: merchant.id).destroy_all

        get merchant_products_path(merchant.id)

        must_respond_with :success
      end

      it 'works with many products' do
        products = Product.where(merchant_id: merchant.id)

        products.count.must_be :>, 0

        get merchant_products_path(merchant.id)

        must_respond_with :success
      end
    end

    describe 'new' do
      it 'succeeds for an authenticated user' do
        get new_merchant_product_path(merchant.id)

        must_respond_with :success
      end
    end

    describe 'create' do

      it "creates a work with valid data" do
        old_product_count = Product.count

        post merchant_products_path(merchant.id), params: { product: product_data }

        must_redirect_to merchant_products_path(merchant.id, Product.last.id)
        Product.count.must_equal old_product_count + 1
      end

      it "renders bad_request and does not update the DB for bogus data for an authenticated user" do
        product_data[:name] = nil

        old_product_count = Product.count

        post merchant_products_path(merchant.id), params: { product: product_data }

        must_respond_with :bad_request
        Product.count.must_equal old_product_count
      end

      it 'adds a default photo if none is given' do
        post merchant_products_path(merchant.id), params: { product: product_data }

        must_respond_with :redirect
        Product.last.photo_url.must_equal "http://www.equistaff.com/Images/noimageavailable.gif"
      end
    end

    describe 'edit' do
      it 'succeeds for an authenticated user' do
        product = merchant.products.first
        get edit_merchant_product_path(merchant.id, product.id)

        must_respond_with :success
      end
    end

    describe 'update' do
      let (:old_product_count) { Product.count }

      it 'succeeds with good data' do
        product = merchant.products.first
        old_product_stock = product.stock

        product_data = {
          name: product.name,
          stock: product.stock - 1,
          price: product.price,
          merchant_id: product.merchant_id
        }

        patch merchant_product_path(merchant.id, product.id), params: { product: product_data }
        product.reload

        must_redirect_to merchant_products_path(merchant.id, product.id)
        Product.count.must_equal old_product_count

        product.stock.must_equal (old_product_stock - 1)
      end

      it 'returns bad_request for bad data' do
        product = merchant.products.first
        old_product_stock = product.stock

        product_data = {
          name: product.name,
          stock: nil,
          price: product.price,
          merchant_id: product.merchant_id
        }

        patch merchant_product_path(merchant.id, product.id), params: { product: product_data }
        product.reload

        must_respond_with :bad_request
        Product.count.must_equal old_product_count

        product.stock.must_equal old_product_stock
      end

      it 'adds a default photo if none is given' do
        product = merchant.products.first
        product_data = {
          product_id: product.id,
          photo_url: nil,
          merchant_id: product.merchant_id,
          stock: 2,
          price: 2.99
        }

        patch merchant_product_path(merchant.id, product.id), params: { product: product_data }

        must_respond_with :redirect
        product.reload
        product.photo_url.must_equal "http://www.equistaff.com/Images/noimageavailable.gif"
      end
    end

    describe 'destroy' do
      let (:product) { merchant.products.first }

      it 'retires an existing product' do
        delete merchant_product_path(merchant.id, product.id)

        product.reload
        product.retired.must_equal true
        must_redirect_to merchant_products_path
      end

      it 'must return not_found for a non-existing product' do
        non_existing_id = Product.last.id + 1
        delete merchant_product_path(merchant.id, non_existing_id)

        must_respond_with :not_found
      end

      it 'will not retire a product that is not associated with the merchant' do
        product = Merchant.where.not(id: merchant.id).first.products.first

        delete merchant_product_path(merchant.id, product.id)

        product.reload
        product.retired.must_equal false
        must_redirect_to merchant_products_path
      end
    end

  end
end
