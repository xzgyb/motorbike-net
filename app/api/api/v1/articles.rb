module Api::V1
  class Articles < Grape::API
    resource :articles do
      
      desc "get articles list"
      get do
        articles = Article.latest.published
        present articles, with: Api::Entities::Article
        respond_ok
      end

      desc 'get a article'
      get ':id' do
        article = Article.find(params[:id])
        present article, with: Api::Entities::Article, export_body: true
        respond_ok
      end
    end
  end
end
