require "test_helper"

describe OrdersController do

  describe "create" do

    it 'adds a valid order' do
      old_order_count = Order.count

      post orders_path

      must_respond_with :redirect
      # must redirect to same path as before

      Order.count.must_equal old_order_count + 1
    end

  end # create
end
