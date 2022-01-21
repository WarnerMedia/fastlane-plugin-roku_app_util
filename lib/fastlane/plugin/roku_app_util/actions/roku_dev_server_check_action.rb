require 'fastlane/action'
require 'fastlane_core/configuration/config_item'
require_relative '../helper/roku_app_util_helper'

module Fastlane
  module Actions
    class RokuDevServerCheckAction < Action
      def self.run(params)
        Helper::RokuAppUtilHelper.roku_dev_server_check(params)
        # If we've gotten this far the Roku dev server checks out
        UI.success("Roku dev server is ready")
      end

      def self.description
        "Checks Roku dev server"
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
                               description: "The IP of the Roku dev target",
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
