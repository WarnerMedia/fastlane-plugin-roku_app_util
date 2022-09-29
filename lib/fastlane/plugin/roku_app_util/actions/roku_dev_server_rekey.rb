require 'fastlane/action'
require 'fastlane_core/configuration/config_item'
require_relative '../helper/roku_app_util_helper'

module Fastlane
  module Actions
    class RokuDevServerRekeyAction < Action
      def self.run(params)
        FastlaneCore::PrintTable.print_values(
          config: params,
          title: 'Summary for roku_dev_server_rekey',
          mask_keys: [:dev_pass, :sign_key]
        )

        Helper::RokuAppUtilHelper.roku_app_rekey(params)

        UI.success('Roku dev server rekeyed')
      end

      def self.description
        'Rekeys Roku dev server'
      end

      # For each option, optional is set to true to prevent forcing Fastlane to be interactive and prompting for input
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :dev_target,
            env_name: 'ROKUAPPUTIL_DEV_TARGET',
            description: 'IP address of the Roku development device',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :dev_user,
            env_name: 'ROKUAPPUTIL_DEV_USER',
            description: 'Roku development username',
            optional: true,
            type: String,
            default_value: 'rokudev'
          ),
          FastlaneCore::ConfigItem.new(
            key: :dev_pass,
            env_name: 'ROKUAPPUTIL_DEV_PASS',
            description: 'Roku development password',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_path,
            env_name: 'ROKUAPPUTIL_APP_PATH',
            description: 'Roku signed application file path',
            optional: true,
            type: String,
            verify_block: proc do |value|
              UI.user_error!('Could not find ZIP file') unless File.exist?(value)
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :sign_key,
            env_name: 'ROKUAPPUTIL_SIGN_KEY',
            description: 'Roku signing key',
            optional: true,
            type: String
          )
        ]
      end

      def self.authors
        ['Blair Replogle']
      end

      def self.is_supported?(platform)
        [:roku].include?(platform)
      end
    end
  end
end
