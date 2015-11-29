#!/usr/bin/env ruby -I.

require 'open-uri'
require 'nokogiri'
require 'pp'
require 'humantime'

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
  title: 'title',
  description: 'description',
  link: 'link',
  timestamp: 'pubDate'
}

rss     = Nokogiri::XML(open ARGV[0] || 'bbc_rss_feed.xml')
info    = rss.xpath(TOP_LEVEL)
items   = rss.xpath(ITEMS)

def traverse(feed, parts)
  parts.each_with_object({}) do |(key, path), object|
    item        = feed.xpath(path)
    object[key] = item.children.to_s unless item.empty?
  end
end

info = traverse(info, INFO_PARTS)

feed_items = items.each_with_object([]) do |item, array|
  array << traverse(item, ITEM_PARTS)
end

pp info
pp items.count
pp feed_items.count
pp feed_items[0]
# puts
# pp info[:title]
# puts
# pp info[:title].children
# puts
# pp info[:title].children.to_s
