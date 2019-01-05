require 'fastlane/action'

module Fastlane
  module Actions
    class NotarizeAction < Action
      def self.run(params)
        UI.message('Notarize plugin is working!')
      end

      def self.description
        'Notarizes a macOS package'
      end

      def self.authors
        ['zeplin']
      end

      def self.available_options
        []
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
