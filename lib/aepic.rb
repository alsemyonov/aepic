# Dependencies
require 'action_controller'
require 'action_view'
require 'inherited_resources'
require 'responders'
require 'kaminari'
require 'has_scope'
begin
require 'apipie-rails'
rescue LoadError => e
  STDERR.puts e
end

# AEpic
require 'aepic/version'
require 'active_support'
require 'active_support/concern'

module Aepic
  extend ActiveSupport::Autoload

  autoload :Controller
  autoload :Engine
  autoload :Schema
  autoload :Responder
  autoload :Serializer

  module Concerns
    extend ActiveSupport::Autoload

    autoload :ApiController
    autoload :Controller
    autoload :Decorator
    autoload :Responder
    autoload :Serializer
  end
end

require 'aepic/engine' if defined?(Rails)
