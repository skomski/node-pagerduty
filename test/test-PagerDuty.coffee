PagerDuty = require '../lib/PagerDuty.coffee'
assert    = require 'assert'

serviceKey = undefined # insert key

throw new Error 'Need serviceKey!' unless serviceKey?

pager = new PagerDuty serviceKey

pager.create 'testError',
  details: {foo: 'bar'}
  cb: (err, response) ->
    throw err if err
    assert.equal response.status, 'success'

    pager.acknowledge response.incident_key ,
      description: 'Got the test error!'
      details: {foo: 'bar'}
      cb: (err, response) ->
        throw err if err
        assert.equal response.status, 'success'

        pager.resolve response.incident_key,
          description: 'Resolved the test error!'
          details: { foo: 'bar'}
          cb: (err, response) ->
            throw err if err
            assert.equal response.status, 'success'
