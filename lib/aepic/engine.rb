# coding: utf-8

require 'aepic'
require 'rails/engine'

module Aepic
  class Engine < Rails::Engine
    initializer 'aepic.mime_types' do
      # Unable to add Mime type synonym (only extension synonyms supported), so reregister JSON
      Mime::Type.unregister :json
      Mime::Type.register 'application/json', :json, %w( text/x-json application/jsonrequest application/vnd.api+json )
      Mime::Type.register 'application/ld+json', :jsonld

      require 'action_controller/metal/renderers'
      ActionController::Renderers.add(:jsonld) do |object, options|
        self.content_type = Mime[:jsonld]
        object.respond_to?(:jsonld) ? object.jsonld.to_json(options) : object
      end
    end
  end
end
