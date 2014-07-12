expect = require('chai').expect
Envirofig = require('../../lib/envirofig')

projectName = 'envirofig-test'

describe 'Envirofig', ->
  describe '#init', ->
    context 'when an environments property can not be found', ->
      it 'should return default values', ->
        config = Envirofig.init {
          namespace: projectName
          cwd: __dirname
        }, {
          environment: 'not-development'
        }

        expect(config.server.port).to.equal 3000
