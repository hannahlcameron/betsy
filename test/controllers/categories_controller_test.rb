require "test_helper"

describe CategoriesController do
  describe'create' do
    let(:merchant) { Merchant.first }
    before do
      login(merchant)
    end

    it 'creates a category with valid data' do
      old_category_count = Category.count

      post categories_path, params: {name: 'test'}

      must_redirect_to merchant_products_path(merchant.id)
      Category.count.must_equal old_category_count + 1
    end

    it 'returns bad_request for bad data' do
      old_category_count = Category.count
      category_name = Category.first.name

      post categories_path, params: {name: category_name}

      must_respond_with :bad_request
      Category.count.must_equal old_category_count
    end

  end
end
