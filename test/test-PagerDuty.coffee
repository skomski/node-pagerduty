PagerDuty = require '../src/PagerDuty.coffee'
assert    = require 'assert'

serviceKey = undefined # insert key

throw new Error 'Specify serviceKey!' unless serviceKey?

pager = new PagerDuty
  serviceKey: serviceKey

pager.create
  description: 'testError'
  details: {foo: 'bar'}
  cb: (err, response) ->
    throw err if err
    assert.equal response.status, 'success'

    pager.acknowledge
      incidentKey: response.incident_key ,
      description: 'Got the test error!'
      details: {foo: 'bar'}
      cb: (err, response) ->
        throw err if err
        assert.equal response.status, 'success'

        pager.resolve
          incidentKey: response.incident_key,
          description: 'Resolved the test error!'
          details: { foo: 'bar'}
          cb: (err, response) ->
            throw err if err
            assert.equal response.status, 'success'
