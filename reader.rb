#!/usr/bin/env ruby -I.

require 'open-uri'
require 'nokogiri'
require 'pp'

TOP_LEVEL = '//channel'
ITEMS     = TOP_LEVEL + '/item'

INFO_PARTS = {
  title:         '/title',
  link:          '/link',
  description:   '/description',
  copyright:     '/copyright',
  image_url:     '/image/url',
  image_caption: '/image/title',
  image_width:   '/image/width',
  image_height:  '/image/height'
}

ITEM_PARTS = {
  title: '/title',
  description: '/description',
  link: '/link',
  timestamp: '/pubDate'
}

rss     = Nokogiri::XML(open 'bbc_rss_feed.xml')
channel = rss.xpath(TOP_LEVEL)
items   = rss.xpath(ITEMS)

def traverse(feed, parts, base = TOP_LEVEL)
  parts.each_with_object({}) do |(key, path), object|
    item = feed.xpath(base + path)
    object[key] = item.children.to_s unless item.empty?
  end
end

info = traverse(rss, INFO_PARTS)

items.each_with_object

pp info
pp items.count
# puts
# pp info[:title]
# puts
# pp info[:title].children
# puts
# pp info[:title].children.to_s
