# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'
require 'tilt/erb'
require 'tilt/sass'

require './reader'
require './helpers'
require './humantime'
require './feedlist'

# RSS display application
class RssApp < Sinatra::Application
  include RssAppHelpers

  def self.feeds
    @feeds ||= FeedList.new
  end

  def feeds
    self.class.feeds
  end

  def new_feed
    @feed = Feed.new(@address || 'bbc_rss_feed.xml')
    @feed_ok = true
  end

  def page_title
    @title
  end

  get('/css/style.css') { scss :style }

  get('/') do
    @title = 'Home'
    erb :index
  end

  get('/feed/*') do
    expires 7200, :public, :must_revalidate
    @title = 'Feed'
    @address = params[:splat][0].sub(%r{(https?):/}, '\1://')

    begin
      new_feed
      @title = feed.title
      @info  = feed.info
      @items = feed.time_sorted_items
    rescue StandardError => e
      @feed_ok = false
      @title = "Cannot load feed at #{@address}"
      @info  = { description: e }
      @items = []
    end

    erb :feed
  end

  get('/humantime') do
    "{
      \"first\": #{params[:first]},
      \"ago\": \"#{HumanTime.new(params[:stamp])}\"
    }"
  end

  private

  attr_reader :feed
end
