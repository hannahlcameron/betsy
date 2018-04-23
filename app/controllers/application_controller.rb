class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def logged_in_merchant
    @merchant = Merchant.find_by(id: session[:merchant_id])
  end

  private

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def require_login
    @merchant = Merchant.find_by(id: session[:user_id])
    unless @merchant
      flash[:error] = 'You must be logged in to do that'
      redirect_back(fallback_location: root_path)
    end
  end

end
