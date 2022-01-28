require 'fastlane/action'
require 'fastlane_core/configuration/config_item'
require_relative '../helper/roku_app_util_helper'

module Fastlane
  module Actions
    class RokuAppPackageAction < Action
      def self.run(params)
        package_file_path = Helper::RokuAppUtilHelper.roku_app_package(params)
        # If we've gotten this far the Roku app has been packaged
        UI.success("Package file path: #{package_file_path}")

        return package_file_path
      end

      def self.description
        "Creates Roku package from application sources"
      end

      def self.authors
        ["Onyx Mueller"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      # For each option, optional is set to true to prevent forcing Fastlane to be interactive and prompting for input
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :dev_target,
                                  env_name: "ROKUAPPUTIL_DEV_TARGET",
                               description: "IP of the Roku development device",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :dev_user,
                                  env_name: "ROKUAPPUTIL_DEV_USER",
                               description: "Roku development username",
                                  optional: true,
                                      type: String,
                             default_value: "rokudev"),
          FastlaneCore::ConfigItem.new(key: :dev_pass,
                                  env_name: "ROKUAPPUTIL_DEV_PASS",
                               description: "Roku development password",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :zip_path,
                                  env_name: "ROKUAPPUTIL_ZIP_PATH",
                               description: "Roku application ZIP file path",
                                  optional: true,
                                      type: String,
                              verify_block: proc do |value|
                                              UI.user_error!("Could not find ZIP file") unless File.exist?(value)
                                            end),
          FastlaneCore::ConfigItem.new(key: :sign_key,
                                  env_name: "ROKUAPPUTIL_SIGN_KEY",
                               description: "Roku signing key",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :app_name,
                                  env_name: "ROKUAPPUTIL_APP_NAME",
                               description: "Roku application name",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :app_version,
                                  env_name: "ROKUAPPUTIL_APP_VERSION",
                               description: "Roku application version",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :pkg_output_path,
                                  env_name: "ROKUAPPUTIL_PKG_OUTPUT_PATH",
                               description: "Output path for pkg",
                                  optional: true,
                                      type: String,
                                      default_value: "./")
        ]
      end

      def self.is_supported?(platform)
        [:roku].include?(platform)
      end
    end
  end
end
