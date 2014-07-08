var Envirofig, confurg, exports, _;

confurg = require('confurg');

_ = require('lodash');

Envirofig = (function() {
  function Envirofig() {}

  Envirofig.init = function(config, defaults) {
    var conf;
    if (config == null) {
      config = {};
    }
    if (defaults == null) {
      defaults = {};
    }
    defaults.environment = (defaults.environment || process.env.NODE_ENV || 'development').toLowerCase();
    conf = confurg.init.apply(null, arguments);
    if (conf.environments != null) {
      return _.merge(conf, conf.environments[defaults.environment]);
    }
  };

  return Envirofig;

})();

exports = module.exports = Envirofig;
