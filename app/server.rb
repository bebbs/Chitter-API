require 'sinatra/base'
require 'json'
require 'data_mapper'
require 'bcrypt'

require_relative '../lib/user.rb'

class ChitterAPI < Sinatra::Base

  env = ENV['RACK_ENV'] || 'development'

  DataMapper.setup(:default, "postgres://localhost/chitter_api_#{env}")

  DataMapper.finalize
  DataMapper.auto_upgrade!

  require './lib/user'

  enable :sessions
  set :session_secret, 'super secret'

  get '/' do
    'Hello ChitterAPI!'
  end

  get '/api' do
    'Hello'
  end

  post '/api/users/new' do
    data = handle_json
    user = User.new(email: data[:email],
                    username: data[:username],
                    display_name: data[:display_name],
                    password: data[:password],
                    password_confirmation: data[:password_confirmation])
    if user.save
      session[:user_id] = user.id 
      status 201 
    else
      halt 500
    end
  end

  post '/api/sessions/new' do
    data = handle_json
    user = User.authenticate(data[:email], data[:password])

    if user
      session[:user_id] = user.id
      status 200
    else
      halt 500
    end
  end

  def handle_json
    content_type :json
    JSON.parse(request.body.read, symbolize_names: true)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
