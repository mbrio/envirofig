expect = require('chai').expect
Envirofig = require('../../lib/envirofig')

projectName = 'envirofig-test'

describe 'Envirofig', ->
  describe '#init', ->
    it 'should return default values when environments are not found', ->
      config = Envirofig.init {
        namespace: projectName
        cwd: __dirname
      }, {
        environment: 'not-development'
      }

      expect(config.server.port).to.equal 3000
