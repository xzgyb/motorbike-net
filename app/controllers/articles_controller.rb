class ArticlesController < ApplicationController
  load_and_authorize_resource :only => [:new, :create, :index, :show, :edit, :publish, :update, :destroy]
  decorates_assigned :articles, :article

  def index
    @articles = Article.latest
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to article_path(@article), notice: '资讯创建成功!'
    else
      render :new
    end
  end

  def update
  end

  def publish
    @article.published = true

    if @article.save
      if from_index_request?(request.referer)
        redirect_to articles_path
      else
        redirect_to article_path(@article), notice: '资讯发布成功!'
      end
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: '资讯删除成功'
  end

  def upload_image
    uploader = ArticleImageUploader.new
    begin
      uploader.store!(params[:upload_file])
      render json: {success: true, msg: '上传成功', file_path: uploader.url}
    rescue CarrierWave::UploadError => error
      render json: {success: false, msg: "上传失败: #{error.message}", file_path: ''}
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :title_picture_url, :body)
    end

    def from_index_request?(url)
      URI.parse(url).path == articles_path
    end
end
