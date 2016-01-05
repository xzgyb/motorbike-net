class ArticlesController < ApplicationController
  load_and_authorize_resource
  decorates_assigned :articles, :article

  def index
  end

  def new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to edit_article_path(@article),
                  notice: '资讯创建成功! 您可以继续编辑咨讯内容或发布资讯.'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def article_params
      params.require(:article).permit(:title, :title_picture_url, :body)
    end
end