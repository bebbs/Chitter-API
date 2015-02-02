require 'spec_helper'
require 'helpers/user_management'

describe 'Posting a peep' do

  context 'As a logged in user' do

    let(:user){User.find{|user| user.email == 'test@abc.com'}}
    let(:body){ {:content => 'This is the first test peep', :token => user.token}.to_json }

    it 'Have no peeps when first signed up' do
      sign_up_and_in
      expect(user.peeps.count).to eq 0
    end

    it 'Can post a peep' do
      sign_up_and_in
      post '/api/peeps/new', body, {'Content-Type' => 'application/json'}
      expect(last_response.body).to include 'This is the first test peep'
    end

  end
  
end