require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'

# RSS display application
class RssApp < Sinatra::Application
  get('/css/style.css') { scss :style }

  get('/') do
    @title = "BBC RSS Feed"
    erb :index
  end

end
