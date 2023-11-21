module ResourceGenerator
  module Generators
    class GraphitiScaffoldGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)
      puts "ResourceGenerator::Generators::GraphitiScaffoldGenerator"

      def create_resource
        template "resource.rb", File.join("app/resources", class_path, "#{file_name}_resource.rb")
      end

      hook_for :test_framework, as: :resource
    end
  end
end
