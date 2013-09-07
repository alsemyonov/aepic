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

      included do
        attributes :id
        embed :ids, include: true
      end

      module ClassMethods
        #def inherited(child)
        #  super
        #  child.root = child.name.gsub(/Serializer$/, '').pluralize.camelcase(:lower)
        #end

        def jsonld_context
          {}.tap do |context|
            schema[:attributes].each do |name, type|
              context[name] = XSD_TYPES[type]
            end
            schema[:associations].each do |name, type|
              associated_class = "#{name.to_s.classify}Decorator".constantize
              context[name] = associated_class.jsonld_context
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

      def attributes
        {'@context' => jsonld_context}.merge(super)
      end

      def jsonld_context
        object.jsonld_context
      end
    end
  end
end
