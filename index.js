module.exports = {
	'parser': 'babel-eslint',
	'extends': 'airbnb',
	'rules': {
		'no-tabs': [0],
		'indent': [2, 'tab'],
		'arrow-parens': [2, 'always'],
		'brace-style': [2, 'stroustrup'],
		'no-underscore-dangle': [0],
		'no-confusing-arrow': [0], // this errors on ternary fatties
		'no-param-reassign': [2, {
			'props': false,
		}],
		'react/jsx-indent': [2, 'tab'],
		'react/jsx-indent-props': [2, 'tab'],
		'react/jsx-filename-extension': [1, {
			'extensions': ['.js'],
		}],
	},
};
