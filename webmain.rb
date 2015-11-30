require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'
require 'tilt/erb'
require 'tilt/sass'
require './reader'

# RSS display application
class RssApp < Sinatra::Application
  get('/css/style.css') { scss :style }

  get('/') do
    @title = 'Home'
    erb :index
  end

  get('/feed/*') do
    @title = 'Feed'
    addr = params[:splat][0].sub 'http:/', 'http://'

    begin
      puts "Addr: #{addr}"
      feed = Feed.new addr || 'bbc_rss_feed.xml'
      @title = feed.info[:title]
      @info  = feed.info
      @items = feed.items.sort_by { |item| Time.parse(item[:timestamp]) }.reverse
    rescue StandardError => e
      @title = "Cannot load feed at #{params[:addr]}"
      @info = {
        description:  e
      }

      @items = []
      warn @title
      warn e
    end

    puts "Loading..."
    p @info
    p @items[0]
    p @items[1]
    erb :feed
  end
end
