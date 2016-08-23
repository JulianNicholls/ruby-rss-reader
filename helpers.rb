# Helper functions for the RSS viewer
module RssAppHelpers
  # It's a utility function so it has :reek:FeatureEnvy
  def linkify(text)
    return '' unless text && text.is_a?(String)

    # return the text unchanged if links are already embedded
    return text if text =~ /<a/

    text.gsub(%r{(https?://\S+)}, '<a href="\1" target="_blank">\1</a>')
  rescue => err
    warn "rescue: #{err.inspect}"
    ''
  end

  # It's a utility function so it has :reek:FeatureEnvy
  def process_cdata(string)
    pos = string =~ /<!\[CDATA\[/

    warn 'CDATA found after string beginning' if pos && pos > 0

    string.gsub(/<!\[CDATA\[([^\]]+)\]\]>/, '\1')
  end

  module_function :linkify
  module_function :process_cdata
end
