class SessionsController < ApplicationController

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']

      @merchant = Merchant.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])

      if @merchant.nil?

        @merchant = Merchant.new(
          username: auth_hash['info']['name'],
          email: auth_hash['info']['email'],
          uid: auth_hash['uid'],
          provider: auth_hash['provider']
        )

        if @merchant.save
          session[:merchant_id] = @merchant.id
          flash[:success] = "Created new merchant and logged in successfully"
        else
          flash[:error] = "Could not log in because merchant failed validations"
          redirect_to root_path
        end

      else
        session[:merchant_id] = @merchant.id
        flash[:success] = "Logged in as existing merchant #{@merchant.username} successfully"
      end

      redirect_to orders_path
    else
      flash[:error] = "Authentication failed. Could not log in."
      redirect_to root_path
    end
  end

  def destroy
    session.delete(:merchant_id)
    flash[:success] = "Logged out successfully."
    redirect_to root_path
  end

end
