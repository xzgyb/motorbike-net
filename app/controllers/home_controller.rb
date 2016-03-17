class HomeController < ApplicationController
  decorates_assigned :articles

  def index
    @articles = Article.latest.published
  end

  def doc
  end
end
