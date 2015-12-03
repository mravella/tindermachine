#!/usr/bin/ruby

require 'pyro'
require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'oauth2'
require 'open-uri'



get '/people/:id' do
  headers["Access-Control-Allow-Origin"] = "file://"
  headers["Content-Type"] = "application/json; charset=utf-8"
  Dir.entries(params['id']).to_json
end
