require "test_helper"

describe OrderitemsController do
  # describe 'new' do
  #   it 'responds with success' do
  #     get new_orderitem_path
  #     must_respond_with :success
  #   end
  # end

  describe 'create' do
    it 'can add a valid orderitem' do
      oi_data = {
        product_id: Product.first.id,
        order_id: Order.first.id,
        quantity: 1
      }

      old_oi_count = OrderItem.count

      OrderItem.new(oi_data).must_be :valid?

      post orderitems_path, params: {orderitem: oi_data}

      must_respond_with :redirect
      must_redirect_to products_path

      OrderItem.count.must_equal old_oi_count + 1

    end

    it "won't add an invalid orderitem" do
      oi_data = {
        product_id: Product.first.id,
        quantity: 1
      }

      old_oi_count = OrderItem.count

      OrderItem.new(oi_data).wont_be :valid?

      post orderitems_path, params: {orderitem: oi_data}

      must_respond_with :bad_request

      OrderItem.count.must_equal old_oi_count
    end
  end

  # describe 'edit' do
  #   it 'responds with success' do
  #     get edit_orderitem_path(OrderItem.last)
  #     must_respond_with :success
  #   end
  #
  #   it 'sends not_found if order_item does not exist' do
  #     orderitem_id = OrderItem.last.id + 1
  #     get orderitem_path(orderitem_id)
  #     must_respond_with :not_found
  #   end
  # end

  describe 'update' do
    it 'updates an existing orderitem with valid data' do
      test_io = OrderItem.first
      oi_data = test_io.attributes
      oi_data[:quantity] = 2

      test_io.assign_attributes(oi_data)
      test_io.must_be :valid?

      patch orderitem_path(test_io), params: { orderitem: oi_data }

      must_redirect_to products_path

      test_io.reload
      test_io.quantity.must_equal oi_data[:quantity]

    end

    it 'sends bad_request for invalid data' do
      test_io = OrderItem.first
      oi_data = test_io.attributes
      oi_data[:quantity] = 20000

      test_io.assign_attributes(oi_data)
      test_io.wont_be :valid?

      patch orderitem_path(test_io), params: { orderitem: oi_data }

      must_respond_with :bad_request
    end

    it 'sends not_found for orderitem that dne' do
      io_id = OrderItem.last.id + 1
      patch orderitem_path(io_id)

      must_respond_with :not_found
    end
  end

  describe 'destroy' do
    it 'responds with success if an orderitem is deleted' do
      io_id = OrderItem.first.id
      old_oi_count = OrderItem.count

      delete orderitem_path(io_id)

      must_respond_with :redirect
      must_redirect_to "order/show"

      OrderItem.count.must_equal old_oi_count - 1
      OrderItem.find_by(id: io_id).must_be_nil
    end

    it 'sends not_found if orderitem dne' do
      io_id = OrderItem.last.id + 1
      old_oi_count = OrderItem.count

      delete orderitem_path(io_id)

      must_respond_with :not_found
      OrderItem.count.must_equal old_oi_count
    end
  end

end
