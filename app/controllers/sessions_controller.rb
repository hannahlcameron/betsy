class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']

      merchant = Merchant.get_user(auth_hash)

      if merchant.nil?
        flash[:error] = "Could not log in because merchant failed validations"
        redirect_to root_path
        return
      end
      session[:merchant_id] = merchant.id
      flash[:success] = 'Successfully logged in'
      redirect_to orders_path
      return
    else
      flash[:error] = 'Could not log in'
    end
    redirect_to root_path
  end

  def destroy
    session.delete(:merchant_id)
    flash[:success] = "Logged out successfully."
    redirect_to root_path
  end

end
