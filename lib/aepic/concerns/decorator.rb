# coding: utf-8

require 'aepic'

module Aepic
  module Concerns
    module Decorator
      extend ActiveSupport::Concern

      module ClassMethods
        def jsonld_context
          @json_context ||= h.polymorphic_url(object_class, format: :jsonld)
        end
      end

      def jsonld_context
        self.class.jsonld_context
      end
    end
  end
end
