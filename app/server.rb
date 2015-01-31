require 'sinatra/base'
require 'json'
require 'data_mapper'
require 'bcrypt'

require_relative '../lib/user.rb'

class ChitterAPI < Sinatra::Base

  env = ENV['RACK_ENV'] || 'development'

  DataMapper.setup(:default, "postgres://localhost/chitter_api_#{env}")

  require './lib/user'

  DataMapper.finalize
  DataMapper.auto_upgrade!

  get '/' do
    'Hello ChitterAPI!'
  end

  get '/api' do
    'Hello'
  end

  post '/api/users/new' do
    content_type :json

    data = JSON.parse(request.body.read, symbolize_names: true)

    @user = User.new(email: data[:email],
                     username: data[:username],
                     display_name: data[:display_name],
                     password: data[:password],
                     password_confirmation: data[:password_confirmation])
    if @user.save
      status 201
    else
      halt 500
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
