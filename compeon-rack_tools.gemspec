# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compeon/rack_tools/version'

Gem::Specification.new do |spec|
  spec.name          = 'compeon-rack_tools'
  spec.version       = Compeon::RackTools::VERSION
  spec.authors       = ['Timo Schilling']
  spec.email         = ['timo@schilling.io']

  spec.summary       = 'COMPEON RackTools'
  spec.description   = 'COMPEON RackTools'
  spec.homepage      = 'https://github.com/COMPEON/compeon-rack_tools'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/COMPEON'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'rack', '>= 2', '< 4'
  spec.add_dependency 'rack-cors'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'compeon-access_token'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
