class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :logged_in_merchant

  def logged_in_merchant
    if session[:merchant_id]
      @merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end

  private

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def require_login
    unless @merchant
      flash[:error] = 'You must be logged in to do that'
      redirect_back(fallback_location: root_path)
    end
  end

end
