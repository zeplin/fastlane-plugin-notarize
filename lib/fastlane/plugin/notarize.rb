require 'fastlane/plugin/notarize/version'

module Fastlane
  module Notarize
    def self.all_classes
      Dir[File.expand_path('**/actions/*.rb', File.dirname(__FILE__))]
    end
  end
end

Fastlane::Notarize.all_classes.each do |current|
  require current
end
