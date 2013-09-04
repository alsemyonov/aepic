# coding: utf-8
require 'aepic'

module Aepic
  module Concerns
    module Serializer
      attributes :id

      XSD_TYPES = Hash.new { |hash, key| hash[key] = "xsd:#{key}"}.merge({
      })

      def self.jsonld_context
        {}.tap do |context|
          schema[:attributes].each do |name, type|
            context[name] = XSD_TYPES[type]
          end
        end
      end

      def self.jsonld
        {'@context' => jsonld_context.merge(xsd: 'http://www.w3.org/2001/XMLSchema#')}
      end

      def attributes
        hash = super
        hash['@context'] = object.jsonld_context
        hash
      end
    end
  end
end
