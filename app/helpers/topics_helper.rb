require 'markdown_render'

module TopicsHelper
  def markdown(text)
    MarkdownRender.markdown(text)
  end
end
