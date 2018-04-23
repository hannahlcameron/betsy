class MerchantsController < ApplicationController
  before_action :require_login, except: [:index, :show]

  # for any user
  def index
    @merchants = Merchant.all
  end

  def show
    merchant_id = params[:id]
    @merchant = Merchant.find_by(id: merchant_id)
  end

  # for the merchant
  def edit
  end

  def update
  end

  def destroy; end # is this necessary?
end
