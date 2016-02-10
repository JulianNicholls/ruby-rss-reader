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
    @title = 'Feed'
    @address = params[:splat][0].sub(%r{(https?):/}, '\1://')

    begin
      new_feed
      @title = feed.title
      @info  = feed.info
      @items = feed.time_sorted_items
    rescue StandardError => err
      @title = "Cannot load feed at #{@address}"
      @info  = { description:  err }
      @items = []
    end

    erb :feed
  end

  get('/humantime') do
    HumanTime.new(params[:stamp]).to_s
  end

  private

  attr_reader :feed
end
