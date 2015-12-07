module MarkdownRender
  module_function
    def markdown(text)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                         autolink: true,
                                         tables: true)
      markdown.render(text)
    end
end