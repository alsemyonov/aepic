# coding: utf-8

require 'aepic'
require 'rails/engine'

module Aepic
  class Engine < Rails::Engine
    initializer 'aepic.mime_types' do
      # Unable to add Mime type synonym (only extension synonyms supported), so reregister JSON
      api_mime_types = %W(
        application/vnd.api+json
        text/x-json
        application/json
      )
      Mime::Type.unregister :json
      Mime::Type.register 'application/json', :json, api_mime_types
      Mime::Type.register 'application/ld+json', :jsonld

      require 'action_controller/metal/renderers'
      ActionController::Renderers.add(:jsonld) do |object, options|
        self.content_type = Mime[:jsonld]
        object.respond_to?(:jsonld) ? object.jsonld.to_json(options) : object
      end

      require 'aepic/concerns/serializer/adapter'
      Aepic::Concerns::Serializer::Adapter.inject!
    end
  end
end
