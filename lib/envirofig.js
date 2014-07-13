var Envirofig, confurg, exports, minimatch, _,
  __slice = [].slice;

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
      return _.merge.apply(_, [conf].concat(__slice.call((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = props.length; _i < _len; _i++) {
          prop = props[_i];
          _results.push(conf.environments[prop]);
        }
        return _results;
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
