expect = require('chai').expect
Envirofig = require('../../lib/envirofig')

projectName = 'envirofig-test'

describe 'Envirofig', ->
  describe '#init', ->
    context 'when no namespace is passed', ->
      it 'should throw an error', ->
        expect(-> Envirofig.init()).to.throw()

    context 'when no environment is specified', ->
      it 'should default to development environment', ->
        config = Envirofig.init
          namespace: projectName
          cwd: __dirname

        expect(config.getEnvironment()).to.equal 'development'
        expect(config.server.port).to.equal 3500

    context 'when an environment is specified', ->
      context 'and the specified environnment could not be found', ->
        it 'should return no environment overrides', ->
          config = Envirofig.init {
            namespace: projectName
            cwd: __dirname
          }, {
            environment: 'not-development'
          }

          expect(config.getEnvironment()).to.equal 'not-development'
          expect(config.server.port).to.equal 3000

      context 'and the specified environment could be found', ->
        it 'should return environment overrides when one is found', ->
          config = Envirofig.init {
            namespace: projectName
            cwd: __dirname
          }, {
            environment: 'production'
          }

          expect(config.getEnvironment()).to.equal 'production'
          expect(config.server.port).to.equal 80

        it 'should add properties', ->
          config = Envirofig.init {
            namespace: projectName
            cwd: __dirname
          }, {
            environment: 'test'
          }

          expect(config.getEnvironment()).to.equal 'test'
          expect(config.server.port).to.equal 8080
          expect(config.message).to.equal 'hello'

    context 'when no environment is specified but is found in global ENV', ->
      it 'should return environment overrides when one is found', ->
        process.env.NODE_ENV = 'production'

        config = Envirofig.init
          namespace: projectName
          cwd: __dirname

        expect(config.getEnvironment()).to.equal 'production'
        expect(config.server.port).to.equal 80

        delete process.env.NODE_ENV

      it 'should add properties', ->
        process.env.NODE_ENV = 'test'

        config = Envirofig.init
          namespace: projectName
          cwd: __dirname

        expect(config.getEnvironment()).to.equal 'test'
        expect(config.server.port).to.equal 8080
        expect(config.message).to.equal 'hello'

        delete process.env.NODE_ENV
