# coding: utf-8
require 'aepic'
require 'active_model_serializers'

module Aepic
  class Serializer < ActiveModel::Serializer
    include Aepic::Concerns::Serializer
  end
end
