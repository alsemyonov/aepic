require 'aepic/version'
require 'active_support'
require 'active_support/concern'

module Aepic
  extend ActiveSupport::Autoload

  autoload :Controller
  autoload :Engine
  autoload :Schema
  autoload :Serializer

  module Concerns
    extend ActiveSupport::Autoload

    autoload :Controller
    autoload :Decorator
    autoload :Responder
    autoload :Serializer
  end
end

require 'aepic/engine' if defined?(Rails)
