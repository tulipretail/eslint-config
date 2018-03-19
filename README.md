# Tulip ESLint

This package provides a set of rules for ESLint to be used in your editor of choice. To install, make sure your `.npmrc` is set up for the internal npm registry, and run:

```
npm i -D @tulip/eslint-config
```

In your `.eslintrc` file, the most simple setup is as follows:

```json
{
	"extends": "@tulip"
}
```

## Editor Setup

Once your project has a valid `.eslintrc` file, you editor needs to know how and when you'd like it to be used. Most editors should be able to work quickly while you type (with a throttle). Below are some examples.

- [SublimeLinter](http://sublimelinter.com/) - Install via Package Control in Sublime.