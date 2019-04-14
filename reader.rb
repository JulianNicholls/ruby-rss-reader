# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require './humantime'
require './helpers'

def add_human_time(item)
  stamp = item[:timestamp]
  item[:time_ago] = HumanTime.new(stamp) if stamp

  item
end

# Take a section of an XML file and traverse it in search of key, value pairs
class ItemTraverser
  include RssAppHelpers

  def initialize(base, parts)
    @base = base
    @parts_list = parts
  end

  def collect
    item = @parts_list.each_with_object({}) do |(key, path), object|
      # Prefixed items can be a problem if they are not present
      begin
        @section = @base.xpath(path.first)
      rescue
        next
      end

      next if @section.empty?
      next object[key] = process_cdata(@section.children.to_s) if path.size == 1

      @section.each do |cur|
        path[1].each do |element|
          key_name = "#{key}_#{element}".to_sym
          object[key_name] = process_cdata(cur[element])
        end
      end
    end

    add_human_time(item)
  end
end

# Load and store a RSS / Atom feed.
class Feed
  TOP_LEVEL = '//channel'
  ITEMS     = '//item'

  INFO_PARTS = {
    title: ['title'],
    link: ['link'],
    description: ['description'],
    copyright: ['copyright'],
    image_url: ['image/url'],
    image_caption: ['image/title'],
    image_width: ['image/width'],
    image_height: ['image/height'],
    timestamp: ['lastBuildDate']
  }.freeze

  ITEM_PARTS = {
    title: ['title'],
    description: ['description'],
    link: ['link'],
    timestamp: ['pubDate'],
    image: ['media:thumbnail', ['url']]
  }.freeze

  def initialize(feed_path)
    # This could be a file or web address. It could raise an exception.
    @rss = Nokogiri::XML open(feed_path)
  end

  def info
    @info ||= load_info
  end

  def items
    @items ||= load_items
  end

  def time_sorted_items
    items.sort_by { |item| Time.parse(item[:timestamp]) }.reverse
  end

  def title
    info[:title]
  end

  private

  def load_info
    info = @rss.xpath(TOP_LEVEL)
    ItemTraverser.new(info, INFO_PARTS).collect
  end

  def load_items
    @rss.xpath(ITEMS).each_with_object([]) do |item, array|
      array << ItemTraverser.new(item, ITEM_PARTS).collect
    end
  end
end

if $PROGRAM_NAME == __FILE__
  require 'awesome_print'

  begin
    addr = ARGV[0] || 'bbc_rss_feed.xml'
    feed = Feed.new(addr)

    ap feed.info
    ap feed.items.size
    ap feed.items.take(5)
  rescue StandardError => e
    warn "Cannot open #{addr}: #{e}"
  end
end
