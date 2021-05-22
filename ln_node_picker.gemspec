require_relative 'lib/ln_node_picker/version'

Gem::Specification.new do |spec|
  spec.name          = "ln_node_picker"
  spec.version       = LnNodePicker::VERSION
  spec.authors       = ["El Tiburon"]
  spec.email         = ["eltib71@protonmail.com"]

  spec.summary       = %q{Pick your lightning nodes with ease}
  spec.description   = "Tool to help you choose lightning nodes to get your " \
    "node started"
  spec.homepage      = "https://github.com/eltib71/ln_node_picker"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] =
    "https://github.com/eltib71/ln_node_picker"
  spec.metadata["changelog_uri"] =
    "https://github.com/eltib71/ln_node_picker/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.files << "lib/ln_node_picker/vendor/eltib71/lightning-tools/channel-analysis/node-recommender/node_recommender.py"

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", ">= 1.0"
  spec.add_runtime_dependency "dry-struct", ">= 1.0"
  spec.add_runtime_dependency "typhoeus", ">= 1.0"
  spec.add_runtime_dependency "awesome_print"
  spec.add_runtime_dependency "light-service"
end
