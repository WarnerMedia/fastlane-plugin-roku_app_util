require 'fastlane/action'
require 'fastlane_core/configuration/config_item'
require_relative '../helper/roku_app_util_helper'

module Fastlane
  module Actions
    class RokuAppUninstallAction < Action
      def self.run(params)
        Helper::RokuAppUtilHelper.roku_app_uninstall(params)
        # If we've gotten this far the Roku apps has been uninstalled
        UI.success("Roku apps uninstalled")
      end

      def self.description
        "Uninstalls any apps/dev channels on a Roku target device"
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
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        [:roku].include?(platform)
      end
    end
  end
end
