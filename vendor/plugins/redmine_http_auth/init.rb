require 'redmine'
require 'dispatcher'
require 'http_auth_patch'
 
Redmine::Plugin.register :redmine_http_auth do
  name 'HTTP Authentication plugin'
  author 'Adam Lantos/A. Martel'
  description 'A plugin for doing HTTP authentication'
  version '0.3.0-dev'
end

Dispatcher.to_prepare do
  #include our code
  ApplicationController.send(:include, HTTPAuthPatch)
end

