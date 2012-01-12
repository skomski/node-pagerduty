PagerDuty = require '../src/PagerDuty.coffee'
assert    = require 'assert'

serviceKey = '12345678901234567890123456789012' # specify key

throw new Error 'Specify serviceKey!' unless serviceKey?

pager = new PagerDuty
  serviceKey: serviceKey

# create incident
pager.create
  description: 'testError'
  details: {foo: 'bar'}
  callback: (err, response) ->
    throw err if err
    assert.equal response.status, 'success'
    console.log 'create'

    # acknowledge incident
    pager.acknowledge
      incidentKey: response.incident_key ,
      description: 'Got the test error!'
      details: {foo: 'bar'}
      callback: (err, response) ->
        throw err if err
        assert.equal response.status, 'success'
        console.log 'acknowledge'

        # resolve incident
        pager.resolve
          incidentKey: response.incident_key,
          description: 'Resolved the test error!'
          details: { foo: 'bar'}
          callback: (err, response) ->
            throw err if err
            assert.equal response.status, 'success'
            console.log 'resolve'

assert.throws () -> 
  new PagerDuty()
, /serviceKey/
console.log 'constructor without serviceKey'

assert.throws () -> 
  pager.create()
, /description/
console.log 'create without description'

assert.throws () -> 
  pager.acknowledge()
, /incident/
console.log 'acknowledge without incidentKey'

assert.throws () -> 
  pager.resolve()
, /incident/
console.log 'resolve without incidentKey'