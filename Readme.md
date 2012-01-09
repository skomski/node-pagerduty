# pagerduty

A node.js client for PagerDuty.

## Install

```
npm install pagerduty
```

## Usage

Sending data:

```coffee
PagerDuty = require 'pagerduty'

pager = new PagerDuty serviceKey

pager.create
  description: 'testError' # required
  details: {foo: 'bar'}
  callback: (err, response) ->
    throw err if err

    pager.acknowledge
      incidentKey: response.incident_key # required
      description: 'Got the test error!'
      details: {foo: 'bar'}
      callback: (err, response) ->
        throw err if err

        pager.resolve
          incidentKey: response.incident_key # required
          description: 'Resolved the test error!'
          details: { foo: 'bar'}
          callback: (err, response) ->
            throw err if err
```

## License

Licensed under the MIT license.
