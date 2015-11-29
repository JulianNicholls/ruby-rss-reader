require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'
require 'tilt/erb'
require './reader'

# RSS display application
class RssApp < Sinatra::Application
  get('/css/style.css') { scss :style }

  get('/') do
    @title = 'Home'
    erb :index
  end

  get('/feed/:addr') do
    @title = 'Feed'

    begin
      puts "Addr: #{params[:addr]}"
      feed = Feed.new params[:addr] || 'bbc_rss_feed.xml'
      @title = feed.info[:title]
      @info  = feed.info
      @items = feed.items
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
    erb :feed
  end
end
