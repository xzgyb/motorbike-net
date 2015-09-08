class PostsController < ApplicationController
  load_resource :topic
  load_and_authorize_resource

  def create
    @post = Post.new(post_params)
    
    @post.topic = @topic
    @post.user  = current_user
    @post.save

    @topic.touch
    
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
    @topic.touch
    redirect_to topic_path(@topic)
  end

  private
    def post_params
      params.require(:post).permit(:text)      
    end
end
