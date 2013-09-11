# coding: utf-8
require 'aepic'
require 'aepic/concerns/responder'

module Aepic
  class Responder < ActionController::Responder
    include Aepic::Concerns::Responder
  end
end
