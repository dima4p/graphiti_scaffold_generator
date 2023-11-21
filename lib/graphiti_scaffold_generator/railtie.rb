require 'rails/railtie'

module GraphitiScaffoldGenerator
  class Railtie < ::Rails::Railtie
    generators do |app|
      Rails::Generators.configure! app.config.generators
      Rails::Generators.hidden_namespaces.uniq!
      require 'graphiti_scaffold_generator/generators/rails/scaffold_controller_generator'
    end
  end
end
