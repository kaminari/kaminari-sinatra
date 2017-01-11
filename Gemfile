# frozen_string_literal: true
source 'https://rubygems.org'

# Specify your gem's dependencies in kaminari-sinatra.gemspec
gemspec

# bundle GH master to load kaminari-core/test directory which is not included in the packaged gems
gem 'kaminari-core', github: 'amatsuda/kaminari'
gem 'kaminari-activerecord', github: 'amatsuda/kaminari'

#FIXME need to bundle AV for now, because the helper still depends on ActionView
gem 'actionview', require: 'action_view'
