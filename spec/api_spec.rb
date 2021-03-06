require 'spec_helper'

describe 'The Chitter API' do
  
  it 'can return a success message to the client' do
    get '/api'
    expect(last_response.status).to eq 200
    expect(last_response.body).to eq('Hello')
  end

  it 'returns an error message for unknown routes' do
    get '/api/blah'
    expect(last_response.status).to eq 404
  end

end