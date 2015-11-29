#!/usr/bin/env ruby -I.

require 'open-uri'
require 'nokogiri'

class Feed
  TOP_LEVEL = '//channel'
  ITEMS     = '//item'

  INFO_PARTS = {
    title:         'title',
    link:          'link',
    description:   'description',
    copyright:     'copyright',
    image_url:     'image/url',
    image_caption: 'image/title',
    image_width:   'image/width',
    image_height:  'image/height'
  }

  ITEM_PARTS = {
    title:       'title',
    description: 'description',
    link:        'link',
    timestamp:   'pubDate'
  }

  def initialize(feed_path)
    @rss = Nokogiri::XML(open feed_path)  # File or URL, could raise
  end

  def info
    @info ||= get_info
  end

  def get_info
    info = @rss.xpath(TOP_LEVEL)
    traverse(info, INFO_PARTS)
  end

  def items
    @items ||= get_items
  end

  def get_items
    items   = @rss.xpath(ITEMS)
    feed_items = items.each_with_object([]) do |item, array|
      array << traverse(item, ITEM_PARTS)
    end
  end

  private

  def traverse(base, parts)
    parts.each_with_object({}) do |(key, path), object|
      item        = base.xpath(path)
      object[key] = item.children.to_s unless item.empty?
    end
  end
end

if $PROGRAM_NAME == __FILE__
  require 'pp'

  begin
    addr = ARGV[0] || 'bbc_rss_feed.xml'
    feed = Feed.new(addr)

    pp feed.info
    pp feed.items.count
    pp feed.items[0]
  rescue StandardError => e
    warn "Cannot open #{addr}: #{e}"
  end
end
