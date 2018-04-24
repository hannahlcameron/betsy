class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  private

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def require_login
    @merchant = Merchant.find_by(id: session[:user_id])
    head :unauthorized unless @merchant
  end
end
