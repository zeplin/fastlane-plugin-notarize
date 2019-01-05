$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'simplecov'

# SimpleCov.minimum_coverage 95
SimpleCov.start

module SpecHelper
end

require 'fastlane'
require 'fastlane/plugin/notarize'

Fastlane.load_actions
