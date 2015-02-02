def sign_up(content)
  post '/api/users/new', content, {'Content-Type' => 'application/json'}
end

def sign_in(content)
  post '/api/tokens', content, {'Content-Type' => 'application/json'}
end

def sign_up_and_in
  new_user = {:email => 'test@abc.com', 
              :username => '@test', 
              :display_name => 'Josh',
              :password => 'test',
              :password_confirmation => 'test' }.to_json
  new_login = {:email => 'test@abc.com', :password => 'test'}.to_json

  post '/api/users/new', new_user, {'Content-Type' => 'application/json'}
  post '/api/tokens', new_login, {'Content-Type' => 'application/json'}
  sign_in(new_login)
end