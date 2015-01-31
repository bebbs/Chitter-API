require 'sinatra/base'
require 'json'

class ChitterAPI < Sinatra::Base
  get '/' do
    'Hello ChitterAPI!'
  end

  get '/api' do
    'Hello'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
