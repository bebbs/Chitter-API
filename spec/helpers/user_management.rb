def sign_up(content)
  post '/api/users/new', content, {'Content-Type' => 'application/json'}
end

def sign_in(content)
  post '/api/tokens', content, {'Content-Type' => 'application/json'}
end