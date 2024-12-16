class ThoughtsController < ApplicationController
  before_action :authorize, except: [:index, :about_me, :work]
  before_action :set_thought, only: [:edit, :update, :destroy]

  def index
    @thoughts = Thought.search_content({
      q: params[:q],
      feel_lucky: params[:feel_lucky],
      more_like_this: params[:more_like_this]
    })
  end

  def about_me
    @thought = Thought.random
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
    if @thought.save
      redirect_to thoughts_path
    end
  end
  
  def update
    if @thought.update(thought_params)
      redirect_to thoughts_path
    end
  end

  def destroy
    if @thought.destroy
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
