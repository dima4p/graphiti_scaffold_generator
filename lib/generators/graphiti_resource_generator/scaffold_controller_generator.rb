module GraphitiResourceGenerator
  module Generators
    class ScaffoldControllerGenerator < Rails::Generators::NamedBase
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      source_root File.expand_path('../templates', __FILE__)

      def create_resource
        template "resource.rb", File.join("app/resources", class_path, "#{file_name}_resource.rb")
      end

      hook_for :test_framework, as: :resource
    end
  end
end
