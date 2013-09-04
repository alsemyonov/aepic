# coding: utf-8
require 'aepic'

module Aepic
  class Schema
    METHODS = {
      :index => :get,
      :show => :get,
      :update => [:put, :patch],
      :create => :post,
      :destroy => :delete,
      :edit => :get,
    }

    def self.default
      @default ||= new
    end

    def resources
      controllers.each do |controller|
        if controller.action_methods.include?('index')

        end
      end
    end

    def controllers
      @controllers ||= Set.new
    end

    def <<(controller)
      controllers << controller
    end

    def method_for(action)
      METHODS[action.to_sym].to_s.upcase
    end
  end
end
