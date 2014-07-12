var Envirofig, confurg, exports, _;

confurg = require('confurg');

_ = require('lodash');

Envirofig = (function() {
  function Envirofig() {}

  Envirofig.prototype.init = function(config, defaults) {
    var conf;
    if (config == null) {
      config = {};
    }
    if (defaults == null) {
      defaults = {};
    }
    defaults.environment = (defaults.environment || process.env.NODE_ENV || 'development').toLowerCase();
    conf = confurg.init.apply(null, arguments);
    conf.getEnvironment = function() {
      return defaults.environment;
    };
    if (conf.environments != null) {
      return _.merge(conf, conf.environments[defaults.environment]);
    } else {
      return conf;
    }
  };

  Envirofig.init = function() {
    var env;
    env = new Envirofig();
    return env.init.apply(env, arguments);
  };

  return Envirofig;

})();

exports = module.exports = Envirofig;
