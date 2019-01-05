# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/notarize/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-notarize'
  spec.version       = Fastlane::Notarize::VERSION
  spec.author        = 'Zeplin, Inc.'
  spec.email         = 'support@zeplin.io'

  spec.summary       = 'fastlane plugin to notarize a macOS package'
  spec.homepage      = "https://github.com/zeplin/fastlane-plugin-notarize"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.112.0')
end
