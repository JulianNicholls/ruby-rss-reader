require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'

# RSS display application
class RssApp < Sinatra::Application

  get('/css/style.css') { scss :style }

  get('/')              { slim :index }

  get '/road/:road' do
    @road_data = road_table.order(:end_date)
                 .where(road: params[:road])
                 .all

    slim :road_data, layout: false
  end

  get '/location/:location' do
    @road_data = like params[:location]
    slim :road_data, layout: false
  end

  private

  def data_file_date
    @data_file_date ||= if Sinatra::Application.development?
                          `heroku config:get DATA_FILE_DATE`.chomp
                        else
                          ENV['DATA_FILE_DATE']
                        end
  end
end
