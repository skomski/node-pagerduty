# pagerduty

A node.js client for PagerDuty.

## Install

```
npm install pagerduty
```

## Usage

```javascript
var pager, PagerDuty;

PagerDuty = require('pagerduty');

pager = new PagerDuty({
  serviceKey: '6839b1801ch1032f8a3c22000a9040cf'
});

pager.create({
  description: 'testError', // required
  details: {
    foo: 'bar'
  },
  callback: function(err, response) {
    if (err) throw err;

    pager.acknowledge({
      incidentKey: response.incident_key, // required
      description: 'Got the test error!',
      details: {
        foo: 'bar'
      },
      callback: function(err, response) {
        if (err) throw err;

        pager.resolve({
          incidentKey: response.incident_key, // required
          description: 'Resolved the test error!',
          details: {
            foo: 'bar'
          },
          callback: function(err, response) {
            if (err) throw err;
          }
        });
      }
    });
  }
});
```

## License

Licensed under the MIT license.
