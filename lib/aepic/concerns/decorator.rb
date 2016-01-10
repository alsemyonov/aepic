# coding: utf-8

require 'aepic'

module Aepic
  module Concerns
    module Decorator
      extend ActiveSupport::Concern

      included do
        delegate :model_name, :active_model_serializer
      end

      module ClassMethods
        def jsonld_context
          @json_context ||= h.polymorphic_url(object_class, format: :jsonld)
        end

        def serializer_class
          # @serializer_class ||= ActiveModel::Serializer.serializer_for(object)
          @serializer_class ||= "#{model_name.name}Serializer".safe_constantize
        end
      end

      delegate :jsonld_context, :serializer_class, to: 'self.class'
    end
  end
end
