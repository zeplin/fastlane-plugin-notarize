require 'fastlane/action'

module Fastlane
  module Actions
    class NotarizeAction < Action
      def self.run(params)
        package_path = params[:package]
        bundle_id = params[:bundle_id]

        # Compress and read bundle identifier only for .app bundle.
        compressed_package_path = nil
        if File.extname(package_path) == '.app'
          compressed_package_path = "#{package_path}.zip"
          Actions.sh(
            "ditto -c -k --rsrc --keepParent \"#{package_path}\" \"#{compressed_package_path}\"",
            log: false
          )

          unless bundle_id
            info_plist_path = File.join(package_path, 'Contents', 'Info.plist')
            bundle_id = Actions.sh(
              "/usr/libexec/PlistBuddy -c \"Print :CFBundleIdentifier\" \"#{info_plist_path}\"",
              log: false
            ).strip
          end
        end

        UI.user_error!('Could not read bundle identifier, provide as a parameter.') unless bundle_id

        apple_id_account = CredentialsManager::AccountManager.new(user: params[:username])

        # Add password as a temporary environment variable for altool.
        ENV['FL_NOTARIZE_PASSWORD'] = apple_id_account.password

        UI.message('Uploading package to notarization service, might take a while')

        notarization_upload_response = Actions.sh(
          "xcrun altool --notarize-app -t osx -f \"#{compressed_package_path || package_path}\" --primary-bundle-id #{bundle_id} -u #{apple_id_account.user} -p @env:FL_NOTARIZE_PASSWORD --output-format xml",
          log: false
        )

        FileUtils.rm_rf(compressed_package_path) if compressed_package_path

        notarization_upload_plist = Plist.parse_xml(notarization_upload_response)
        notarization_request_id = notarization_upload_plist['notarization-upload']['RequestUUID']

        UI.success("Successfully uploaded package to notarization service with request identifier #{notarization_request_id}")

        notarization_info = {}
        while notarization_info.empty? || (notarization_info['Status'] == 'in progress')
          if notarization_info.empty?
            UI.message('Waiting to query request status')
          else
            UI.message('Request in progress, waiting to query again')
          end

          sleep(30)

          UI.message('Querying request status')

          notarization_info_response = Actions.sh(
            "xcrun altool --notarization-info #{notarization_request_id} -u #{apple_id_account.user} -p @env:FL_NOTARIZE_PASSWORD --output-format xml",
            log: false
          )

          notarization_info_plist = Plist.parse_xml(notarization_info_response)
          notarization_info = notarization_info_plist['notarization-info']
        end

        log_url = notarization_info['LogFileURL']
        log_suffix = ''
        if log_url
          log_response = Net::HTTP.get(URI(log_url))
          log_json_object = JSON.parse(log_response)
          log_suffix = ", with log:\n#{JSON.pretty_generate(log_json_object)}"
        end

        case notarization_info['Status']
        when 'success'
          UI.message('Stapling package')

          Actions.sh(
            "xcrun stapler staple \"#{package_path}\"",
            log: false
          )

          UI.success("Successfully notarized and stapled package#{log_suffix}")
        when 'invalid'
          UI.user_error!("Could not notarize package with message '#{notarization_info['Status Message']}'#{log_suffix}")
        else
          UI.crash!("Could not notarize package with status '#{notarization_info['Status']}'#{log_suffix}")
        end
      ensure
        ENV.delete('FL_NOTARIZE_PASSWORD')
      end

      def self.description
        'Notarizes a macOS app'
      end

      def self.authors
        ['zeplin']
      end

      def self.available_options
        username = CredentialsManager::AppfileConfig.try_fetch_value(:apple_dev_portal_id)
        username ||= CredentialsManager::AppfileConfig.try_fetch_value(:apple_id)

        [
          FastlaneCore::ConfigItem.new(key: :package,
                                       env_name: 'FL_NOTARIZE_PACKAGE',
                                       description: 'Path to package to notarize, e.g. .app bundle or disk image',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find package at '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :bundle_id,
                                       env_name: 'FL_NOTARIZE_BUNDLE_ID',
                                       description: 'Bundle identifier to uniquely identify the package',
                                       optional: true,
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: 'FL_NOTARIZE_USERNAME',
                                       description: 'Apple ID username',
                                       default_value: username,
                                       default_value_dynamic: true)
        ]
      end

      def self.is_supported?(platform)
        platform == :mac
      end
    end
  end
end
