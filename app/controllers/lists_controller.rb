class ListsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def create
    @list = current_user.lists.build(list_params)
    if @list.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @lists = current_user.lists.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @list.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def list_params
    params.require(:list).permit(:content)
  end
  
  def correct_user
    @list = current_user.lists.find_by(id: params[:id])
    unless @list
      redirect_to root_url
    end
  end
end
