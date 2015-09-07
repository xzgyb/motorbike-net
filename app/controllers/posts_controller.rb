class PostsController < ApplicationController
  before_action :set_topic, only: [:edit, :create, :destroy, :update]
  before_action :set_post, only: [:edit, :destroy, :update]

  def create
    @post = Post.new(post_params)
    
    @post.topic = @topic
    @post.user  = current_user
    @post.save
    
    redirect_to topic_path(@topic) 
  end

  def destroy
    @post.destroy
    redirect_to topic_path(@topic)
  end

  def edit
    render layout: 'topics' 
  end

  def update
    @post.update_attributes(post_params)
    redirect_to topic_path(@topic)
  end

  private
    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    def set_post
      @post = Post.find(params[:id])
    end
    
    def post_params
      params.require(:post).permit(:text)      
    end
end
