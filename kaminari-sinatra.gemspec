# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kaminari/sinatra/version'

Gem::Specification.new do |spec|
  spec.name          = "kaminari-sinatra"
  spec.version       = Kaminari::Sinatra::VERSION
  spec.authors       = ["Akira Matsuda"]
  spec.email         = ["ronnie@dio.jp"]

  spec.summary       = 'Kaminari Sinatra adapter'
  spec.description   = 'Kaminari Sinatra adapter'
  spec.homepage      = 'https://github.com/kaminari/kaminari-sinatra'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '< 2.9'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'rr'
  spec.add_development_dependency 'sinatra-contrib'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'database_cleaner'
  spec.add_dependency 'kaminari-core'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'actionview'
  spec.add_dependency 'padrino-helpers'
end
