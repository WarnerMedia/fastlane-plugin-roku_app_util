require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class RokuAppUtilHelper
      def self.roku_dev_server_check(params)
        validate_params(params, [:dev_target])

        target = params[:dev_target]

        # Check if device is on the network and responding with a quick ping
        ping_args = ''
        if FastlaneCore::Helper.linux?
          ping_args = '-c 1 -w 1'
        elsif FastlaneCore::Helper.mac?
          ping_args = '-c 1 -W 1'
        else
          ping_args = '-c 1'
        end

        `ping #{ping_args} #{target}`
        if $?.exitstatus != 0
          UI.shell_error!('Device is not responding to ping')
        end

        # Check ECP, to verify we are talking to a Roku
        check_device_response = `curl --connect-timeout 2 --silent http://#{target}:8060`
        if $?.exitstatus != 0
          UI.shell_error!('Device is not responding to ECP - is it a Roku?')
        end

        parsed_device_names = validate_response_match(check_device_response, %r{<friendlyName>(.*?)</friendlyName>}m)
        # Message the device friendly name
        UI.message("Device reports as #{parsed_device_names[0]}")

        # Check the dev web server - check to see if the developer mode is enable
        `curl --connect-timeout 2 --silent http://#{target}`

        if $?.exitstatus != 0
          UI.shell_error!('Device server is not responding - is the developer mode enabled?')
        end
      end

      def self.roku_app_install(params)
        roku_dev_server_check(params)

        validate_params(params, [:dev_user, :dev_pass, :zip_path])

        # Variables
        # roku username when enable the developer mode
        user = params[:dev_user]
        # roku password when enable the developer mode
        pass = params[:dev_pass]
        # roku device ip
        target = params[:dev_target]
        # Complete path where the zip lives
        zip_path = params[:zip_path]
        # curl timeout value
        timeout = 10
        user_pass = "#{user}:#{pass}"

        output = `curl --user #{user_pass} --digest --silent --show-error --connect-timeout #{timeout} -F \"mysubmit=Install\" -F \"archive=@#{zip_path}\" http://#{target}/plugin_install`

        # Check exit code
        if $?.exitstatus != 0
          UI.shell_error!("Curl exit code #{$?.exitstatus}. See URL for meaning: https://everything.curl.dev/usingcurl/returns#available-exit-codes")
        end

        parsed_responses = validate_response_match(output, %r{<font color="red">(.*?)</font>}m)
        result = parsed_responses[0]
        # Dev server installation output will display 'Application Received' if app is installed successfully (or already is)
        unless result.include?("Application Received")
          UI.shell_error!("Error from Roku: #{result}")
        end
      end

      def self.roku_app_uninstall(params)
        roku_dev_server_check(params)

        validate_params(params, [:dev_user, :dev_pass])

        # Variables
        # roku username when enable the developer mode
        user = params[:dev_user]
        # roku password when enable the developer mode
        pass = params[:dev_pass]
        # roku device ip
        target = params[:dev_target]
        user_pass = "#{user}:#{pass}"

        http_status = `curl --user #{user_pass} --digest --silent --show-error -F \"mysubmit=Delete\" -F \"archive=\" --write-out \"%{http_code}\" http://#{target}/plugin_install`

        # Check exit code
        if $?.exitstatus != 0
          UI.shell_error!("Curl exit code #{$?.exitstatus}. See URL for meaning: https://everything.curl.dev/usingcurl/returns#available-exit-codes")
        end
        parsed_responses = validate_response_match(http_status, %r{<font color="red">(.*?)</font>}m)
        result = parsed_responses[0]

        # Dev server uninstall build will display 'Delete Succeeded' result if app is uninstalled successfully
        unless result.include?("Delete Succeeded.")
          UI.message("Uninstall failed - was the app installed? Result from Roku: #{result}")
        end
      end

      def self.roku_app_package(params)
        roku_app_install(params)

        validate_params(params, [:sign_key, :app_name, :app_version])

        # Variables
        # roku username when enable the developer mode
        user = params[:dev_user]
        # roku password when enable the developer mode
        pass = params[:dev_pass]
        # roku device ip
        target = params[:dev_target]
        # developer's signing key (from genkey)
        sign_key = params[:sign_key]
        # application name
        app_name = params[:app_name]
        # application version
        app_version = params[:app_version]
        # pkg_output_path: default to current folder
        pkg_output_path = params[:pkg_output_path]

        user_pass = "#{user}:#{pass}"
        app_name_version = "#{app_name}/#{app_version}"
        current_time = Time.now.strftime('%s')

        # Package POST to roku device
        package_output = `curl --user #{user_pass} --digest --silent --show-error -F \"mysubmit=Package\" -F \"app_name=#{app_name_version}\" -F \"passwd=#{sign_key}\" -F \"pkg_time=#{current_time}\" http://#{target}/plugin_package`
        # Check exit code
        if $?.exitstatus != 0
          UI.shell_error!("Curl exit code #{$?.exitstatus}. See URL for meaning: https://everything.curl.dev/usingcurl/returns#available-exit-codes")
        end

        parsed_responses = validate_response_match(package_output, %r{<font color="red">(.*?)</font>}m)
        result = parsed_responses[0]
        # Dev server installation output will display 'Success' if app is packaged successfully
        unless result.include?("Success")
          UI.shell_error!("Error from Roku: #{result}")
        end

        UI.success("Roku app signed")
        UI.message("Starting the package download")

        # If there isn't error you should find the zip url inside a '<a>' tag
        package_output_matched = validate_response_match(package_output, %r{<a href="pkgs//(.*?)"})
        # Set the name of the file should be the first match
        package_name = package_output_matched[0]

        # Use a combination of the app name & version for the output package file name
        output_package_file = "#{app_name}_#{app_version}.pkg".gsub(' ', '_')
        # download and rename package to pkg_output_path
        Dir.chdir(pkg_output_path) do
          `curl --user #{user_pass} --digest --silent --show-error --output #{output_package_file} http://#{target}/pkgs/#{package_name}`
          # Check exit code
          if $?.exitstatus != 0
            UI.shell_error!("Curl exit code #{$?.exitstatus}. See URL for meaning: https://everything.curl.dev/usingcurl/returns#available-exit-codes")
          end

          # Check if file exists
          unless File.file?(output_package_file.to_s)
            UI.shell_error!("Unable to download package")
          end
        end
        # Return the full path to the output package file
        return File.expand_path(output_package_file)
      end

      def self.roku_app_rekey(params)
        validate_params(params, [:dev_target, :dev_user, :dev_pass, :sign_key, :app_path])

        target = params[:dev_target]
        user = params[:dev_user]
        pass = params[:dev_pass]
        sign_key = params[:sign_key]
        app_path = params[:app_path]
        user_pass = "#{user}:#{pass}"
        current_time = DateTime.now.strftime('%Q')

        cmd = ['curl']
        cmd << "--user #{user_pass}"
        cmd << "--digest"
        cmd << "--silent"
        cmd << "show-error"
        cmd << "-F mysubmit=Rekey"
        cmd << "-F passwd=#{sign_key}"
        cmd << "-F archive=@#{app_path}"
        cmd << "-F pkg_time=#{current_time}"
        cmd << "http://#{target}/plugin_inspect"
        cmd = cmd.join(' ')

        response = `#{cmd}`

        # Check exit code
        if $?.exitstatus != 0
          UI.shell_error!("Curl exit code #{$?.exitstatus}. See URL for meaning: https://everything.curl.dev/usingcurl/returns#available-exit-codes")
        end

        parsed_responses = validate_response_match(response, %r{<font color="red">(.*?)</font>}m)
        result = parsed_responses[0]

        # Dev server installation output will display 'Success' if app is packaged successfully
        unless result.include?("Success")
          UI.shell_error!("Error from Roku: #{result}")
        end

        UI.success("Roku device rekeyed")
      end


      # A helper method to check if all the necessary parameters are set
      # params: An array containing all the parameters to check
      # keys: An array of keys to use in params
      def self.validate_params(params, keys)
        # Check if required parameter is defined, if not throw the error
        keys.each do |key|
          value = params[key]
          if value.nil? || (value.size == 0)
            UI.user_error!("#{key} parameter is not set")
          end
        end
      end

      # Helper to check if a response from a curl match the desired regex
      # response: All the response from the curl
      # regex: Regular expression/pattern to be search in the response
      def self.validate_response_match(response, regex)
        if response.nil? || (response.size == 0)
          UI.shell_error!("Device returned no output")
        end
        output_matched = response.match(regex)
        if output_matched.nil? || (output_matched.size == 0)
          UI.shell_error!("Unexpected output")
        end
        possible_matches = output_matched.captures
        if possible_matches.nil? || (possible_matches.size == 0)
          UI.shell_error!("Couldn't parse results")
        end
        return possible_matches
      end
    end
  end
end
