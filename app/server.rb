require 'sinatra/base'
require 'json'
require 'data_mapper'
require 'bcrypt'
require 'securerandom'

require_relative '../lib/user.rb'
require_relative '../lib/peep.rb'

class ChitterAPI < Sinatra::Base

  env = ENV['RACK_ENV'] || 'development'

  DataMapper.setup(:default, "postgres://localhost/chitter_api_#{env}")

  DataMapper.finalize
  DataMapper.auto_upgrade!

  require './lib/user'

  get '/api' do
    'Hello'
  end

  post '/api/users/new' do
    data = handle_json
    user = User.new(email: data['email'],
                    username: data['username'],
                    display_name: data['display_name'],
                    password: data['password'],
                    password_confirmation: data['password_confirmation'])
    user.save ? (status 201) : (halt 500)

  end

  post '/api/tokens' do
    data = handle_json
    user = User.authenticate(data['email'], data['password'])
    user ? (generate_token(user)) : (status 401)
  end

  delete '/api/tokens' do
    data = handle_json
    user = verify_user(data)
    user ? remove_token(user) : (status 403)
  end

  post '/api/peeps/new' do
    data = handle_json
    user = verify_user(data)
    peep = Peep.new(content: data['content'], user_id: user.id, created_at: Time.now)
    if peep.save
      peep.to_json
    else 
      halt 500
    end
  end

  def handle_json
    content_type :json
    JSON.parse(request.body.read)
  end

  def generate_token(user)
    token = SecureRandom.hex(16)
    user.token = token
    user.save
    {'token' => user.token}.to_json
  end

  def verify_user(data)
    User.find{|user| user.token == data['token']}
  end

  def remove_token(user)
    user.token = nil
    {"token" => user.token}.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
