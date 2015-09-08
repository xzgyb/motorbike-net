class TopicsController < ApplicationController
  respond_to :html
  load_and_authorize_resource

  def index
    @topics = Topic.recent_topics.paginate(page: params[:page], per_page: 30)
  end

  def show
    @topic.inc(views_count: 1)
    @posts = @topic.posts.paginate(page: params[:page], per_page: 30)
    @last_post = Topic.last_post(@topic)

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
