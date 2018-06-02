class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  def index
    #@tasks = Task.all
    if logged_in?
      @user = current_user
      @task = current_user.tasks.build  # form_for 用
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
    end
  end

  def show
    #@tasks = Task.find(params[:id])
    @tasks = current_user.tasks.find_by(id: params[:id])
  end

  def new
    #@tasks = Task.new
    @tasks = current_user.tasks.new
  end

  def create
    @tasks = current_user.tasks.build(task_params)

    if @tasks.save
      flash[:success] = 'タスクが正常に反映されました'
      redirect_to @tasks
    else
      flash.now[:danger] = 'タスクが反映されませんでした'
      render :new
    end
  end

  def edit
    @tasks = current_user.tasks.find_by(id: params[:id])
  end

  def update
    @tasks = current_user.tasks.find_by(id: params[:id])

    if @tasks.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @tasks
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    #@tasks = Task.find(params[:id])
    @tasks.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end  
  
  def correct_user
    @tasks = current_user.tasks.find_by(id: params[:id])
    unless @tasks
      redirect_to root_url
    end
  end
end
