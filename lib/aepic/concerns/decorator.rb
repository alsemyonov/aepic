# coding: utf-8

module Aepic
  module Concerns
    module Decorator
      def jsonld_context
        h.polymorphic_url(object.class, format: :jsonld)
      end
    end
  end
end
