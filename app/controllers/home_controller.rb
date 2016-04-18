class HomeController < ApplicationController
  decorates_assigned :articles

  def index
    @articles = Article.latest.published
  end

  def doc
    redirect_to "/docs/index.html"
  end
end
