require 'aepic'
require 'responders'

module Aepic
  module Concerns
    module Responder
      extend ActiveSupport::Concern

      include Responders::HttpCacheResponder

      private

      def do_http_cache?
        get? && (@http_cache != false) && persisted? && resource_item.respond_to?(:updated_at)
      end

      # @return [Boolean]
      def do_http_cache!
        resource_item = resource_item.object if resource_item.is_a?(Draper::Decorator)

        last_modified = resource_item.try(:updated_at) || Time.at(0)
        etag = resource_collection

        resource_collection.each do |resource|
          resource = resource.object if resource.is_a?(Draper::Decorator)
          last_modified = resource.updated_at if resource.updated_at > last_modified
        end if resource_collection.length > 1

        !controller.stale?(etag: etag, last_modified: last_modified)
      end

      # @return [Array] array of resources
      def resource_collection
        @resource_collection ||= resource.is_a?(Array) ? resource : resources
      end

      # @return [Object] just one resource
      def resource_item
        @resource_item ||= resource.is_a?(Array) ? resource.last : resource
      end
    end
  end
end
