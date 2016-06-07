class TopicsController < ApplicationController
  respond_to :html
  load_and_authorize_resource
  decorates_assigned :topics, :topic, :post, :posts

  def index
    @topics = Topic.recent_topics.page(params[:page])
  end

  def show
    @topic.update_attribute(:views_count, @topic.views_count + 1)
    @posts = @topic.posts.page(params[:page])
    @post = Post.new
  end
  
  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.user = current_user
    @topic.save

    respond_with(@topic, location: topics_path)
  end

  def edit
    render :new
  end

  def update
    @topic.update_attributes(topic_params)
    respond_with(@topic, location: topics_path)
  end

  def destroy
    @topic.destroy
    redirect_to topics_path
  end

  private
    def topic_params
      params.require(:topic).permit(:subject, :text)
    end
end
