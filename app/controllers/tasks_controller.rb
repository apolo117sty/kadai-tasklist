class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_tasks, only: [:show, :edit, :update, :destroy]
  before_action :include_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = "タスクが正常に登録されました"
      redirect_to root_url
    else
      flash.now[:danger] = "タスクが登録できませんでした"
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = "タスクは正常に更新されました"
      redirect_to @task
    else
      flash.now[:danger] = "タスクは更新されませんでした"
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    
    flash[:success] = "タスクは正常に削除されました"
    redirect_to tasks_url
  end

  private
  
  def set_tasks
    @task = Task.find_by(id: params[:id])
  end
  
  def include_task
    if current_user.tasks.include?(@task)
    else
      redirect_to root_url
    end
  end
  
  #Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status, :name_id)
  end
end