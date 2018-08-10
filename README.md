# Tulip ESLint

This package provides a set of rules for ESLint to be used in your editor of choice. To install, simply run:

```bash
npm i -D @tulipjs/eslint-config
```

In your `.eslintrc` file, the most simple setup is as follows:

```json
{
	"extends": "@tulipjs"
}
```

## Contributing

If you come across a rule you think should be changed, you can open an Issue or Pull Request in this repo to start a discussion. Link to the official docs for the rule in question on [ESLint's site](https://eslint.org/) and make your case! This is meant to be a living document and it should evolve over time. Run `npm run test` to make sure you didn't add any ESLint errors to this repo.

### Branch Naming

Since editing the lint config might not relate to a task or user story, give your branch a descriptive name, perhaps after the rule in question. 

## Editor Setup

Once your project has a valid `.eslintrc` file, you editor needs to know how and when you'd like it to be used. Most editors should be able to work quickly while you type (with a throttle). Below are some examples.

- [SublimeLinter](http://sublimelinter.com/) - Install via Package Control in Sublime.
