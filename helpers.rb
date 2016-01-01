# Helper functions for the RSS viewer
module RssAppHelpers
  def linkify(text)
    if text && text.is_a?(String)
      text.gsub(%r{(https?://\S+)}, '<a href="\1" target="_blank">\1</a>')
    else
      warn "NAS: #{text.inspect}"
      ''
    end
  rescue => err
    warn "rescue: #{err.inspect}"
    ''
  end

  module_function :linkify
end
