confurg = require 'confurg'
_ = require 'lodash'

# Public: Coffeescript and Javascript configuration loader with knowledge of
# it's environment
class Envirofig
  # Public: Initializes [confurg](https://github.com/awnist/confurg) with an
  # environmental parameter then looks at the resulting configuration {Object}
  # to determine if environmental configurations have been specified, if one
  # is found matching the specified environment then it's values will be merged
  # in.
  #
  # In order to determine the environment name to use envirofig first looks
  # at the `defaults` argument for a property `environment`, if it does not
  # exist it then looks at `process.env.NODE_ENV`, if it does not exist it
  # defaults to the *development* environment. Before searching for environment
  # overrides it lower-cases the environment name.
  #
  # In order to find an environment override within the configuration {Object}
  # envirofig looks within the `environments` property for a property that
  # matches the specified environment.
  #
  # ```coffee
  # # Example CSON config file
  # serverPort: 3000
  # environments:
  #   production:
  #     serverPort: 80
  # ```
  #
  # For information pertaining to configuration files see
  # [confurg](https://github.com/awnist/confurg).
  #
  # config - An {Object} containing a configuration for confurg, see
  #          [confurg](https://github.com/awnist/confurg)
  # defaults - An {Object} containing defaults for confurg, see
  #            [confurg](https://github.com/awnist/confurg)
  #
  # ```coffee
  # # In this example we assume the environment has been set to *development*
  # # and we are using the config file above
  # config = require('envirofig').init 'project-name'
  # console.log config.serverPort
  # # => 3000
  # ```
  #
  # ```coffee
  # # In this example we assume the environment has been set to *production*
  # # and we are using the config file above
  # config = require('envirofig').init 'project-name'
  # console.log config.serverPort
  # # => 80
  # ```
  #
  # Returns an {Object} containing the values from the merged confurg file
  init: (config = {}, defaults = {}) ->
    defaults.environment = (defaults.environment or process.env.NODE_ENV or
      'development').toLowerCase()

    conf = confurg.init.apply null, arguments

    if conf.environments?
      _.merge conf, conf.environments[defaults.environment]
    else
      conf

  # Public: Creates an {Envirofig} instance and calles init
  @init: ->
    env = new Envirofig
    env.init.apply env, arguments

exports = module.exports = Envirofig
