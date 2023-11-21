# frozen_string_literal: true

module Rspec
  class ResourceGenerator < ::Rails::Generators::NamedBase
    argument :attributes, type: :array, default: [], banner: "field:type field:type"
    source_root File.expand_path("templates", __dir__)

    def create_resource_spec
      template "resource_spec.rb", File.join("spec/resources", class_path, "#{file_name}_resource_spec.rb")
    end
  end
end
