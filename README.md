# Fastlane `roku_app_util` plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-roku_app_util)
[![Test](https://github.com/WarnerMedia/fastlane-plugin-roku_app_util/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/WarnerMedia/fastlane-plugin-roku_app_util/actions/workflows/test.yml)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-roku_app_util`, add it to your project by running:

`fastlane add_plugin roku_app_util`

__If the command prompts you with an option, select Option 3: RubyGems.org.__

## About roku_app_util

Fastlane plugin for Roku app automation. All actions require a Roku dev server on the same network as the machine running the following Fastlane actions.

### Available actions
* [`roku_dev_server_check`](#action-roku_dev_server_check) : Checks Roku dev server
* [`roku_app_install`](#action-roku_app_install) : Installs the app as a dev channel on a Roku target device
* [`roku_app_uninstall`](#action-roku_app_uninstall) : Uninstalls any apps/dev channels on a Roku target device
* [`roku_app_package`](#action-roku_app_package) : Creates Roku package from application sources

#### Action: `roku_dev_server_check`

##### Description: Checks Roku dev server

##### Parameters:

Key  | Environment Variable Equivalent | Description | Required?
------------- | ------------- | ------------- | -------------
`dev_target`  | `ROKUAPPUTIL_DEV_TARGET` | The IP of the Roku dev target | YES

#### Action: `roku_app_install`

##### Description: Installs the app as a dev channel on a Roku target device

##### Parameters:

Key  | Environment Variable Equivalent | Description | Required?
------------- | ------------- | ------------- | -------------
`dev_target`  | `ROKUAPPUTIL_DEV_TARGET` | The IP of the Roku dev target | YES
`dev_user`    | `ROKUAPPUTIL_DEV_USER`   | Roku development username | NO - Default value: `rokudev`
`dev_pass`    | `ROKUAPPUTIL_DEV_PASS`   | Roku development password | YES
`zip_path`    | `ROKUAPPUTIL_ZIP_PATH`   | Roku application ZIP file path | YES

#### Action: `roku_app_uninstall`

##### Description: Uninstalls any apps/dev channels on a Roku target device

##### Parameters:

Key  | Environment Variable Equivalent | Description | Required?
------------- | ------------- | ------------- | -------------
`dev_target`  | `ROKUAPPUTIL_DEV_TARGET` | The IP of the Roku dev target | YES
`dev_user`    | `ROKUAPPUTIL_DEV_USER`   | Roku development username | NO - Default value: `rokudev`
`dev_pass`    | `ROKUAPPUTIL_DEV_PASS`   | Roku development password | YES

#### Action: `roku_app_package`

##### Description: Creates Roku package from application sources

##### Parameters:

Key  | Environment Variable Equivalent | Description | Required?
------------- | ------------- | ------------- | -------------
`dev_target`  | `ROKUAPPUTIL_DEV_TARGET` | The IP of the Roku dev target | YES
`dev_user`    | `ROKUAPPUTIL_DEV_USER`   | Roku development username | NO - Default value: `rokudev`
`dev_pass`    | `ROKUAPPUTIL_DEV_PASS`   | Roku development password | YES
`zip_path`    | `ROKUAPPUTIL_ZIP_PATH`   | Roku application ZIP file path | YES
`sign_key`    | `ROKUAPPUTIL_SIGN_KEY`   | Roku signing key | YES
`app_name`    | `ROKUAPPUTIL_APP_NAME`   | Roku application name | YES
`app_version` | `ROKUAPPUTIL_APP_VERSION`| Roku application version | YES
`pkg_output_path` | `ROKUAPPUTIL_PKG_OUTPUT_PATH`| Roku application PKG path | NO - Default value: `./`

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
bundle exec rake
```

To automatically fix many of the styling issues, use
```
bundle exec rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).

## License

This repository is released under [the MIT license](https://en.wikipedia.org/wiki/MIT_License).  View the [local license file](./LICENSE).
