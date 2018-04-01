class ThoughtsController < ApplicationController
  before_action :authorize, except: [:index, :about_me, :work]
  before_action :set_thought, only: [:edit, :update, :destroy]

  def index
    @thoughts = Thought.all.order(created_at: :desc)
  end

  def about_me
    @thoughts = Thought.recent
  end

  def work
  end

  def edit
  end

  def new
    @thought = Thought.new
  end

  def create
    @thought = Thought.new(thought_params)
    if @thought.save!
      redirect_to thoughts_path
    end
  end
  
  def update
    if @thought.update_attributes(thought_params)
      redirect_to thoughts_path
    end
  end

  def destroy
    if @thought.destroy!
      redirect_to thoughts_path
    end
  end

  private
  def thought_params
    params.require(:thought).permit(:content)
  end

  def set_thought
    @thought = Thought.find(params[:id])
  end
end
