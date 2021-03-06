# coding: utf-8
require 'aepic'
require 'active_support/concern'
require 'inherited_resources'
require 'has_scope'
require 'kaminari'

module Aepic
  module Concerns
    module Controller
      extend ActiveSupport::Concern

      included do
        inherit_resources
        self.perform_caching = true
        self.responder = Aepic::Responder

        respond_to :json
        respond_to :jsonld, only: :index

        has_scope :ids, only: :index do |_controller, scope, ids|
          if ids.present?
            ids = ids.to_s.split(',').map { |id| id.to_i }
            scope.where(id: ids)
          else
            scope
          end
        end
        has_scope :sort, only: :index do |_controller, scope, fields|
          ordering = fields.to_s.split(',').map do |field|
            field.start_with?('-') ? "#{field} ASC" : "#{field[1..-1]} DESC"
          end.join(', ')
          scope.order(ordering)
        end

        has_scope :page, only: :index, default: '1'
        has_scope :per, only: :index
        has_scope :per_page, only: :index do |controller, scope, value|
          value ? scope.per(value) : scope
        end
        helper_method :resource_serializer

        include Overrides

        api_schema << self

        include ApiController
      end

      module ClassMethods
        # @return [ActiveModel::Serializer]
        def resource_serializer
          resource_class.active_model_serializer
        end

        # @return [Draper::Decorator]
        def resource_decorator
          "#{resource_class.name}Decorator".safe_constantize
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
        def resource_decorator
          self.class.resource_decorator
        end

        # @return [Draper::Decorator]
        def resource
          get_resource_ivar || set_resource_ivar(resource_decorator.decorate(super))
        end

        # @return [Draper::Decorator]
        def build_resource
          get_resource_ivar || set_resource_ivar(resource_decorator.decorate(super))
        end

        # @return [Draper::CollectionDecorator]
        def collection
          get_collection_ivar || set_collection_ivar(resource_decorator.decorate_collection(super))
        end

        # @see http://jsonapi.org/format/
        # Singular resources are represented as JSON objects.
        # However, they are still wrapped inside an array:
        # {"posts": [{ ... }]}
        # This simplifies processing, as you can know that a resource key
        # will always be a list.
        def _render_option_json(resource, options)
          options[:meta] ||= {}

          etags = combine_etags(resource)
          key = ActiveSupport::Cache.expand_cache_key(etags)
          etag = %("#{Digest::MD5.hexdigest(key)}")
          options[:meta][:etag] = etag

          resource = Array.wrap(resource) unless resource.respond_to?(:length)
          if resource.respond_to?(:total_count)
            options[:meta][:total] = resource.total_count
          end

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
