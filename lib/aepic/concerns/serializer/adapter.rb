require 'aepic'

module Aepic
  module Concerns
    module Serializer
      module Adapter
        def self.inject!
          require 'active_model/serializer/adapter/json_api'
          ActiveModel::Serializer::Adapter::JsonApi.send(:include, self)
        end

        def meta_for(serializer)
          STDERR.puts 'Add total_pages'
          meta = super(serializer)
          meta.merge({ total_pages: serializer.total_pages, total_count: serializer.total_count, size: serializer.size }) if serializer.respond_to?(:total_pages)
          meta
        end
      end
    end
  end
end
