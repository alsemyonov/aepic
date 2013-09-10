require 'aepic'
require 'responders'

module Aepic
  module Concerns
    module Responder
      extend ActiveSupport::Concern

      include Responders::HttpCacheResponder

      def initialize(controller, resources, options={})
        resources = resources.last if resources.last.is_a?(Array)
        super(controller, resources, options)
        @http_cache = options.delete(:http_cache)
      end

      private

      def do_http_cache?
        puts resources.inspect
        puts resource.inspect
        get?.tap { |gt| puts "get: #{gt}"  } && (@http_cache != false).tap { |gt| puts "http_cache: #{gt}"  }  &&
          persisted?.tap { |gt| puts "persisted?: #{gt}"  }  && resourceful?.tap { |gt| puts "resourceful?: #{gt}"  } && resource.respond_to?(:updated_at).tap { |gt| puts "respond_to?: #{gt}"  }
      end

      # @return [Boolean]
      def do_http_cache!
        puts resources, resource
        last_modified = resource.updated_at
        etag = resources

        resources.each do |resource|
          last_modified = resource.updated_at if resource.updated_at > last_modified
        end if resources.length > 1

        !controller.stale?(etag: resources, last_modified: last_modified)
      end
    end
  end
end
