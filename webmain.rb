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

  get('/css/style.css') { scss :style }

  get('/') do
    @title = 'Home'
    erb :index
  end

  get('/feed/*') do
    @title = 'Feed'
    @address = params[:splat][0].sub(%r{(https?):/}, '\1://')

    begin
      feed = Feed.new @address || 'bbc_rss_feed.xml'
      @title = feed.info[:title]
      @info  = feed.info
      @items = feed.items.sort_by { |item| Time.parse(item[:timestamp]) }.reverse
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
end
