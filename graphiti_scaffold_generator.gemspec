# frozen_string_literal: true

require_relative "lib/graphiti_scaffold_generator/version"

Gem::Specification.new do |spec|
  spec.name = "graphiti_scaffold_generator"
  spec.version = GraphitiScaffoldGenerator::VERSION
  spec.authors = ["Dmitry Kulikov"]
  spec.email = ["dima@koulikoff.ru"]

  spec.summary = "When gem 'graphiti' is in use generates code for app/resources and /spec/resources for scaffold"
  spec.description = <<-DESCRIPTION
The graphiti gem has no support for scaffold generator.
This gem fiexes the problem. When you generate scaffold for a model
you'll get the correct controller, specs for the request and, of course,
the code for /app/resources and /spec/resources
DESCRIPTION
  spec.homepage = "https://github.com/dima4p/graphiti_scaffold_generator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  #spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
