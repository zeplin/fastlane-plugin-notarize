# Deprecated

Notarize action is now officially a part of fastlane. 🦄 The plugin will be no longer be supported and further improvements and fixes will be made on the official action. Please migrate over to the new action by simply removing the plugin from your Pluginfile and updating Fastlane to the latest version.

# fastlane notarize plugin [![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-notarize)

[fastlane](https://github.com/fastlane/fastlane) plugin to [notarize](https://developer.apple.com/documentation/security/notarizing_your_app_before_distribution) a macOS app. 🛂

Notarize plugin provides a `notarize` action to upload an app to Apple's notarization service, querying the result periodically until it's complete—which currently takes around 2 minutes. In case of success, it staples the app with the notarization ticket. In case of failure, it prints the log file listing all the issues.

## Getting started

To get started, add it to your project:

```bash
fastlane add_plugin notarize
```

Update your `Fastfile` to use the `notarize` action:
```ruby
notarize(
    package: app_path, # Path to package to notarize, e.g. .app bundle or disk image
    bundle_id: bundle_id # Not required for .app bundles, bundle identifier to uniquely identify the package.
)
```

This action should prompt you for an Apple ID and password, using fastlane's built-in credentials manager. To use the action in a CI environment like Bitrise, CircleCI or Travis CI, you can set `FASTLANE_USER` and `FASTLANE_PASSWORD` environment variables. (Make sure to use secret environment variables, specifically for the password.)

The tool also stores the `log file url` in an environment variable called `FL_NOTARIZE_LOG_FILE_URL` for further use after the notarization. The log file contains information about errors and/or warnings that arose during notarization.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `bundle exec fastlane test`.

## Testing

To run both the tests and code style validation, run:

```bash
rake
```

To automatically fix many of the styling issues, use:
```bash
rubocop -a
```

## Troubleshooting

If you have trouble using fastlane plugins, check out fastlane's [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## About fastlane

fastlane is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).

For more information about how the fastlane plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).
