confurg = require 'confurg'
minimatch = require 'minimatch'
_ = require 'lodash'

# Public: Coffeescript and Javascript configuration loader with support for
# environment based overrides.
class Envirofig
  # Public: Initializes [Confurg](https://github.com/awnist/confurg), once
  # complete it determines the requested application environment and merges any
  # overrides.
  #
  # In order to determine the requested application environment Envirofig first
  # looks at the supplied `defaults` argument for a property named
  # `environment`; if not found, it looks at `process.env.NODE_ENV`; if the
  # global `NODE_ENV` variable is not set it uses the default *development*
  # environment.
  #
  # In order to find an environment override within the configuration {Object}
  # Envirofig looks within the `environments` property for a child property that
  # matches the specified environment name. Property name matching is done
  # utilizing a glob.
  #
  # The application environment can be a name (e.g. test, development, or
  # production) or it can be a glob, as specified above (e.g. dev*). In either
  # case Envirofig uses a case-insensitive property search on the configuration
  # object.
  #
  # ```coffee
  # # Example CSON config file
  # serverPort: 3000
  # environments:
  #   development:
  #     serverPort: 8080
  #     debug: true
  #   production:
  #     serverPort: 80
  # ```
  #
  # For information pertaining to configuration files see
  # [Confurg](https://github.com/awnist/confurg).
  #
  # config - An {Object} containing a configuration for Confurg, see
  #          [Confurg](https://github.com/awnist/confurg)
  # defaults - An {Object} containing defaults for Confurg, see
  #            [Confurg](https://github.com/awnist/confurg)
  #
  # ```coffee
  # # In this example we assume the environment has been set to *development*
  # # and we are using the config file above
  # config = require('envirofig').init 'project-name'
  # console.log config.serverPort
  # # => 8080
  # console.log config.debug
  # # => true
  # ```
  #
  # ```coffee
  # # In this example we assume the environment has been set to *production*
  # # and we are using the config file above
  # config = require('envirofig').init 'project-name'
  # console.log config.serverPort
  # # => 80
  # console.log config.debug
  # # => undefined
  # ```
  #
  # Returns an {Object} containing the values from the merged Confurg file with
  # the addition of the following key:
  #   getEnvironment: A {Function} that returns the determined environment name
  init: (config = {}, defaults = {}) ->
    defaults.environment = (defaults.environment or process.env.NODE_ENV or
      'development').toLowerCase()

    conf = confurg.init.apply null, arguments

    # Public: Gets the currently determined environment
    #
    # Returns a {String} environment name
    conf.getEnvironment = -> defaults.environment

    if conf.environments?
      props = minimatch.match Object.keys(conf.environments),
        defaults.environment, { nonull: false, nocase: true }

      _.merge conf, (conf.environments[prop] for prop in props)...
    else
      conf

  # Public: Creates an {Envirofig} instance and calles init
  @init: ->
    env = new Envirofig()
    env.init.apply env, arguments

exports = module.exports = Envirofig
