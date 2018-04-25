class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :logged_in_merchant
  before_action :set_cart


  private
  def set_cart
    # will need to clear this somehow
    @cart = Order.where(status: 'pending').last
  end

  def logged_in_merchant
    if session[:merchant_id]
      @logged_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def require_login
    unless @logged_merchant
      flash[:error] = 'You must be logged in to do that'
      redirect_back(fallback_location: root_path)
    end
  end

end
