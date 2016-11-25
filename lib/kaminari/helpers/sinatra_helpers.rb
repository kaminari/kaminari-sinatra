# frozen_string_literal: true
require 'active_support/core_ext/object'
require 'active_support/core_ext/string'
require 'padrino-helpers'
require 'kaminari/helpers/helper_methods'

module Kaminari::Helpers
  module SinatraHelpers
    class << self
      def registered(app)
        app.register Padrino::Helpers
        app.helpers  HelperMethods
        @app = app
      end

      def view_paths
        @app.views
      end

      alias included registered
    end

    class ActionViewTemplateProxy < ActionView::Base
      def initialize(current_path: nil, param_name: nil, current_params: nil)
        super()

        @current_path = current_path
        @param_name = param_name || Kaminari.config.page_method_name
        @current_params = current_params || {}
        @current_params.delete(@param_name)

        view_paths << SinatraHelpers.view_paths
        view_paths << File.join(Gem.loaded_specs['kaminari-core'].gem_dir, 'app/views')
      end

      def url_for(params)
        return params if String === params

        extra_params = {}
        if (page = params[@param_name]) && (Kaminari.config.params_on_first_page || (page.to_i != 1))
          extra_params[@param_name] = page
        end
        query = @current_params.merge(extra_params)
        @current_path + (query.empty? ? '' : "?#{query.to_query}")
      end

      def params
        @current_params
      end
    end

    module SinatraHelperMethods
      def url_for(params)
        current_path = env['PATH_INFO'] rescue nil
        current_params = Rack::Utils.parse_query(env['QUERY_STRING']) rescue {}

        extra_params = params.dup
        extra_params.delete :only_path

        query = current_params.merge(extra_params)
        res = current_path + (query.empty? ? '' : "?#{query.to_query}")
        res
      end

      def link_to_if(condition, name, options = {}, html_options = {}, &block)
        options = url_for(options) if options.is_a? Hash
        if condition
          link_to(name, options, html_options)
        elsif block_given?
          capture_html(&block).html_safe
        else
          name
        end
      end

      def link_to_unless(condition, name, options = {}, html_options = {}, &block)
        link_to_if !condition, name, options, html_options, &block
      end

      def paginate(scope, options = {})
        current_path = env['PATH_INFO'] rescue nil
        current_params = Rack::Utils.parse_query(env['QUERY_STRING']).symbolize_keys rescue {}

        template = ActionViewTemplateProxy.new current_params: current_params, current_path: current_path, param_name: options[:param_name] || Kaminari.config.param_name

        super scope, {template: template}.merge(options)
      end
    end
    Kaminari::Helpers::HelperMethods.prepend SinatraHelperMethods
  end
end

if defined? I18n
  I18n.load_path += Dir.glob(File.join(Gem.loaded_specs['kaminari-core'].gem_dir, 'config/locales/*.yml'))
end
