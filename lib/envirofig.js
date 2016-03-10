var Envirofig, _, confurg, exports, minimatch,
  slice = [].slice;

confurg = require('confurg');

minimatch = require('minimatch');

_ = require('lodash');

Envirofig = (function() {
  function Envirofig() {}

  Envirofig.prototype.init = function(config, defaults) {
    var conf, prop, props;
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
      props = minimatch.match(Object.keys(conf.environments), defaults.environment, {
        nonull: false,
        nocase: true
      });
      return _.merge.apply(_, [conf].concat(slice.call((function() {
        var i, len, results;
        results = [];
        for (i = 0, len = props.length; i < len; i++) {
          prop = props[i];
          results.push(conf.environments[prop]);
        }
        return results;
      })())));
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
