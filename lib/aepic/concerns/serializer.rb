# coding: utf-8
require 'aepic'

module Aepic
  module Concerns
    module Serializer
      extend ActiveSupport::Concern

      XSD_TYPES = Hash.new do |hash, key|
        hash[key] = "xsd:#{key}"
      end.merge({
      })

      included { attributes :id }

      module ClassMethods
        def jsonld_context
          {}.tap do |context|
            schema[:attributes].each do |name, type|
              context[name] = XSD_TYPES[type]
            end
            schema[:associations].each do |name, type|
              class_name = name.to_s
              if class_name =~ /_ids?\Z/
                context[name] = 'xsd:integer'
              else
                class_name = name.to_s.classify
                associated_class = "#{class_name}Decorator".constantize
                context[name] = associated_class.jsonld_context
              end
            end
          end
        end

        def jsonld
          {'@context' => {xsd: 'http://www.w3.org/2001/XMLSchema#'}.merge(jsonld_context)}
        end
      end

      #def root_name
      #  self.class._root
      #end

      def attributes(options = {})
        {'@context' => jsonld_context}.merge(super(options))
      end

      def jsonld_context
        object.jsonld_context
      end
    end
  end
end
