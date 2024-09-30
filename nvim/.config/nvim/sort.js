const { DEFAULT_CONFIGS, getConfig } = require('import-sort-config');
const filePath = process.argv[2];
const content = process.argv[3];

const { extname, dirname } = require('path');
// change the current directory to the directory of this file, so we get the config from here, `.eslintrc.js`
process.chdir(dirname(__filename));

const { default: importSort } = require('import-sort');

const fileName = filePath.split('/').pop();

function clone(object) {
  return JSON.parse(JSON.stringify(object));
}

const config = clone(DEFAULT_CONFIGS);
const defaultSortStyle = "eslint";

Object.keys(config).forEach((key) => {
  config[key].style = `import-sort-style-${defaultSortStyle}`;
});

const cachedConfig = getConfig(
  extname(fileName),
  dirname(__filename),
  config
);

const result = importSort(
  content,
  cachedConfig.parser,
  cachedConfig.style,
  fileName,
  cachedConfig.options
);

console.log(result.code);
