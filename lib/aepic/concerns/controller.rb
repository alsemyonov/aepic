# coding: utf-8
require 'aepic'
require 'active_support/concern'
require 'inherited_resources'

module Aepic
  module Concerns
    module Controller
      extend ActiveSupport::Concern

      included do
        inherit_resources

        respond_to :json
        respond_to :jsonld, only: :index

        has_scope :ids, only: :index do |controller, scope, ids|
          ids = ids.to_s.split(',').map { |id| id.to_i }
          scope.where(id: ids)
        end
        helper_method :resource_serializer

        include Overrides

        api_schema << self
      end

      module ClassMethods
        # @return [ActiveModel::Serializer]
        def resource_serializer
          resource_class.active_model_serializer
        end

        def api_schema
          @api_schema ||= Schema.default
        end
      end

      module Overrides
        protected

        # @return [ActiveModel::Serializer]
        def resource_serializer
          self.class.resource_serializer
        end

        # @return [Draper::Decorator]
        def resource
          get_resource_ivar || set_resource_ivar(super.decorate)
        end

        # @return [Draper::Decorator]
        def build_resource
          get_resource_ivar || set_resource_ivar(super.decorate)
        end

        # @return [Draper::CollectionDecorator]
        def collection
          get_collection_ivar || set_collection_ivar(super.decorate)
        end

        # @see http://jsonapi.org/format/
        # Singular resources are represented as JSON objects.
        # However, they are still wrapped inside an array:
        # {"posts": [{ ... }]}
        # This simplifies processing, as you can know that a resource key
        # will always be a list.
        def _render_option_json(resource, options)
          resource = Array.wrap(resource)

          json = ActiveModel::Serializer.build_json(self, resource, options)

          if json
            super(json, options)
          else
            super
          end
        end
      end
    end
  end
end
