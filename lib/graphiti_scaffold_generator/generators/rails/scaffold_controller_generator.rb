require 'rails/generators'
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'

module Rails
  module Generators
    class ScaffoldControllerGenerator < NamedBase
      source_paths.unshift File.expand_path('../templates', __FILE__)

      class_option :graphiti_resource_generator,
          desc: 'Generates the graphiti resource',
          default: 'graphiti_resource_generator'
      hook_for :graphiti_resource_generator, required: true
    end
  end
end

module Rspec
  module Generators
    class ScaffoldGenerator < Base
      class_option :api_version, type: :string,
          desc: "Defines the version of the api'",
          default: 'v1'
      source_paths.unshift File.expand_path('../templates', __FILE__)
    end
  end
end
