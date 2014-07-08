should = require 'should'
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

      config.server.port.should.equal 3000
