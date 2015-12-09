require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'
require 'tilt/erb'
require 'tilt/sass'

require './reader'
require './helpers'
require './humantime'

# RSS display application
class RssApp < Sinatra::Application
  include RssAppHelpers

  get('/css/style.css') { scss :style }

  get('/') do
    @title = 'Home'
    erb :index
  end

  get('/feed/*') do
    @title = 'Feed'
    addr = params[:splat][0].sub(%r{(https?):/}, '\1://')

    begin
      # puts "Addr: #{addr}"
      feed = Feed.new addr || 'bbc_rss_feed.xml'
      @title = feed.info[:title]
      @info  = feed.info
      @items = feed.items.sort_by do |item|
        Time.parse(item[:timestamp])
      end.reverse
    rescue StandardError => err
      @title = "Cannot load feed at #{params[:addr]}"
      @info = {
        description:  err
      }

      @items = []
      warn @title
      warn err
    end

    # puts "Loading..."
    # p @info
    # p @items[0]
    # p @items[1]
    erb :feed
  end

  get('/humantime') do
    HumanTime.new(params[:stamp]).to_s
  end
end
