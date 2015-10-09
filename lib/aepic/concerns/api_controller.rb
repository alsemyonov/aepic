# coding: utf-8
require 'aepic'
require 'active_support/concern'
require 'apipie-rails'
require 'apipie/validator/integer_validator'

module Aepic
  module Concerns
    module ApiController
      extend ActiveSupport::Concern

      included do
        has_api!
      end

      module ClassMethods
        def has_api!
          human_name = resource_class.model_name.human
          param_group_id = "#{resource_class.model_name.singular}_id".to_sym
          param_group_resource = resource_class.model_name.singular.to_sym
          param_group_id_resource = "#{resource_class.model_name.singular}_resource".to_sym

          resource_description do
            formats ['json']
            error 404, 'Missing'
            error 500, 'Server crashed for some reason'
          end

          if block_given?
            yield
          else
            def_param_group(param_group_id) do
              param :id, Integer, "ID of #{human_name}"
            end
            columns = resource_class.columns_hash
            def_param_group(param_group_resource) do
              param param_group_resource, Hash, action_aware: true do
                columns.each do |name, column|
                  param name.to_sym, column.sql_type.classify.safe_constantize || String, required: !column.null unless name == 'id'
                  # STDERR.puts "params :#{name}, #{column.sql_type.classify.safe_constantize || String}"
                end
              end
            end
            def_param_group(param_group_id_resource) do
              param_group(param_group_id)
              param_group(param_group_resource)
            end
          end

          class_eval do
            api! "List #{human_name.pluralize}"
            formats %w(json jsonld)

            def index
              super
            end

            api! "Show #{human_name}"
            param_group(param_group_id)

            def show
              super
            end

            api! "Create #{human_name}"
            param_group(param_group_resource)

            def create
              super
            end

            api! "Update #{human_name}"
            param_group(param_group_id_resource)

            def update
              super
            end

            api! "Delete #{human_name}"
            param_group(param_group_id)

            def destroy
              super
            end
          end
        end
      end
    end
  end
end
