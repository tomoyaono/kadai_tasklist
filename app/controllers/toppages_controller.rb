class ToppagesController < ApplicationController
  def index
    if logged_in?
      @user = current_user
      @list = current_user.lists.build
      @lists = current_user.lists.order('created_at DESC').page(params[:page])
    end
  end
end
