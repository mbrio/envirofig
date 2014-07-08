should = require 'should'
Envirofig = require('../src/envirofig')

projectName = 'envirofig-test'

describe 'Envirofig', ->
  describe '#init', ->
    it 'should default to development environment', ->
      config = Envirofig.init
        namespace: projectName
        cwd: __dirname

      config.server.port.should.equal 3500

    it 'should return no environment overrides when one is not found', ->
      config = Envirofig.init {
        namespace: projectName
        cwd: __dirname
      }, {
        environment: 'not-development'
      }

      config.server.port.should.equal 3000

    it 'should return environment overrides when one is found', ->
      config = Envirofig.init {
        namespace: projectName
        cwd: __dirname
      }, {
        environment: 'production'
      }

      config.server.port.should.equal 80

    it 'should add properties when environment overrides are found', ->
      config = Envirofig.init {
        namespace: projectName
        cwd: __dirname
      }, {
        environment: 'test'
      }

      config.server.port.should.equal 8080
      config.message.should.equal 'hello'

    it 'should add properties when global environment overrides are found', ->
      process.env.NODE_ENV = 'test'

      config = Envirofig.init
        namespace: projectName
        cwd: __dirname

      config.server.port.should.equal 8080
      config.message.should.equal 'hello'

      delete process.env.NODE_ENV
