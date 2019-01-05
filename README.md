# fastlane notarize plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-notarize)

[fastlane](https://github.com/fastlane/fastlane) plugin to notarize a macOS package. To get started, add it to your project:

```bash
fastlane add_plugin notarize
```

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
