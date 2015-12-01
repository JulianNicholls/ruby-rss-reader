# Helper functions for the RSS viewer
module RssAppHelpers
  def linkify(text)
    text.gsub(%r{(https?://\S+)}, '<a href="\1" target="_blank">\1</a>')
  end

  module_function :linkify
end
