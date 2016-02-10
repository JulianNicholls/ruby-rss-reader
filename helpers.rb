# Helper functions for the RSS viewer
module RssAppHelpers
  # It's a utility function so it has :reek:FeatureEnvy
  def linkify(text)
    return '' unless text && text.is_a?(String)

    text.gsub(%r{(https?://\S+)}, '<a href="\1" target="_blank">\1</a>')
  rescue => err
    warn "rescue: #{err.inspect}"
    ''
  end

  module_function :linkify
end
