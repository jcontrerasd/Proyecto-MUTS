const {paths} = require('./');

const { override: customizeCraOverride, addBabelPlugin } = require('customize-cra');
const override = require(paths.configOverrides);

const webpackOverride = typeof override === 'function'
  ? override
  : override.webpack || ((config, env) => config);

// Función para combinar la configuración de webpack de customize-cra y cualquier otra personalización
const combinedWebpackOverride = (config, env) => {
  let newConfig = webpackOverride(config, env); // Aplica personalizaciones existentes
  newConfig = customizeCraOverride(
    addBabelPlugin("@babel/plugin-proposal-optional-chaining")
  )(newConfig, env); // Aplica el plugin de optional chaining
  return newConfig;
};

if (override.devserver) {
  console.log(
    'Warning: `devserver` has been deprecated. Please use `devServer` instead as ' +
    '`devserver` will not be used in the next major release.'
  )
}

const devServer = override.devServer || override.devserver
  || ((configFunction) =>
    (proxy, allowedHost) =>
      configFunction(proxy, allowedHost));

const jest = override.jest || ((config) => config);

const pathsOverride = override.paths || ((paths, env) => paths);

module.exports = {
  webpack: combinedWebpackOverride,
  devServer,
  jest,
  paths: pathsOverride,
};

