const PrettierConfig = {
  importOrderParserPlugins: ['importAssertions', 'typescript', 'jsx'],
  plugins: [
    '@ianvs/prettier-plugin-sort-imports',
    // MUST come last: https://www.npmjs.com/package/prettier-plugin-tailwindcss#compatibility-with-other-prettier-plugins
    'prettier-plugin-tailwindcss',
  ],
  trailingComma: 'es5',
  // defined in .editorconfig
  // tabWidth: 2,
  semi: true,
  singleQuote: true,
  singleAttributePerLine: true,
  htmlWhitespaceSensitivity: 'strict',
};

export default PrettierConfig;
