require 'pyro'
require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'oauth2'
require 'open-uri'

# From https://www.facebook.com/dialog/oauth?client_id=464891386855067&redirect_uri=https://www.facebook.com/connect/login_success.html&scope=basic_info,email,public_profile,user_about_me,user_activities,user_birthday,user_education_history,user_friends,user_interests,user_likes,user_location,user_photos,user_relationship_details&response_type=token
FACEBOOK_TOKEN = ''

# From http://graph.facebook.com/your_fb_username
FACEBOOK_ID = ''

pyro = TinderPyro::Client.new
pyro.sign_in(FACEBOOK_ID, FACEBOOK_TOKEN)

users = pyro.get_nearby_users.parsed_response["results"]
num_users = users.length

# TO GET 1000 Images:
# count = 0
# while count < 1000
#   if num_users <= 0
#     users = pyro.get_nearby_users.parsed_response["results"]
#     num_users = users.length
#   end
#
#   user = users.delete_at(0)
#   num_users -= users.length
#
#   File.open(user['_id'].to_s+'.jpg', 'wb') do |fo|
#     fo.write open(user['photos'][0]['url']).read
#   end
#
#   pyro.dislike(user['_id'])
#   count += 1
# end



get '/newuser' do
  if num_users <= 0
    users = pyro.get_nearby_users.parsed_response["results"]
    num_users = users.length
  end
  user = users.delete_at(0)
  num_users -= users.length
  user.to_json
end

get '/like/:id' do
  pyro.like(params['id']).to_json
end

get '/dislike/:id' do
  pyro.dislike(params['id']).to_json
end

get '/info/:id' do
  pyro.info_for_user(params['id']).to_json
end

get '/people/:id' do
  headers["Access-Control-Allow-Origin"] = "file://"
  headers["Content-Type"] = "application/json; charset=utf-8"
  Dir.entries(params['id']).to_json
end
