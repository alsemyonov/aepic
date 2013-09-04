# coding: utf-8

require 'aepic'

module Aepic
  module Concerns
    module Decorator
      include ActiveSupport::Concern

      def jsonld_context
        h.polymorphic_url(object.class, format: :jsonld)
      end
    end
  end
end
