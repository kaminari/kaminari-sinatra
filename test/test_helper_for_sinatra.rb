# frozen_string_literal: true
require 'kaminari/sinatra'
require 'rack/test'
require 'sinatra/test_helpers'
require 'capybara'
require 'nokogiri'

require 'fake_app/sinatra_app'

Capybara.app = SinatraApp
