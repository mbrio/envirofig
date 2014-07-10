expect = require('chai').expect
Envirofig = require('../../lib/envirofig')

projectName = 'envirofig-test'

describe 'Envirofig', ->
  describe '#init', ->
    it 'should default to development environment', ->
      config = Envirofig.init
        namespace: projectName
        cwd: __dirname

      expect(config.server.port).to.equal 3500

    it 'should error if no namespace is passed', ->
      throwError = -> Envirofig.init()
      expect(throwError).to.throw()

    it 'should return no environment overrides when one is not found', ->
      config = Envirofig.init {
        namespace: projectName
        cwd: __dirname
      }, {
        environment: 'not-development'
      }

      expect(config.server.port).to.equal 3000

    it 'should return environment overrides when one is found', ->
      config = Envirofig.init {
        namespace: projectName
        cwd: __dirname
      }, {
        environment: 'production'
      }

      expect(config.server.port).to.equal 80

    it 'should add properties when environment overrides are found', ->
      config = Envirofig.init {
        namespace: projectName
        cwd: __dirname
      }, {
        environment: 'test'
      }

      expect(config.server.port).to.equal 8080
      expect(config.message).to.equal 'hello'

    it 'should add properties when global environment overrides are found', ->
      process.env.NODE_ENV = 'test'

      config = Envirofig.init
        namespace: projectName
        cwd: __dirname

      expect(config.server.port).to.equal 8080
      expect(config.message).to.equal 'hello'

      delete process.env.NODE_ENV
