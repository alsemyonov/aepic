require 'aepic/version'
require 'active_support'

module Aepic
  extend ActiveSupport::Autoload

  autoload :Controller
  autoload :Schema

  module Concerns
    extend ActiveSupport::Autoload

    autoload :Controller
    autoload :Serializer
  end
end
