request = require 'request'

class PagerDuty
  module.exports = PagerDuty

  constructor: ({@serviceKey}) ->
    throw new Error 'PagerDuty.constructor: Need serviceKey!' unless @serviceKey?

  create: ({description, incidentKey, details, callback}) ->
    throw new Error 'PagerDuty.create: Need description!' unless description?

    @_request
      eventType: 'trigger'
      description: description
      incidentKey: incidentKey
      details: details
      cb: callback


  acknowledge: ({incidentKey, details, description, callback}) ->
    throw new Error 'PagerDuty.acknowledge: Need acknowledge!' unless incidentKey?

    @_request
      eventType: 'acknowledge'
      incidentKey: incidentKey
      details: details
      description: description
      cb: callback


  resolve: ({incidentKey, details, description, callback}) ->
    throw new Eror 'PagerDuty.resolve: Need incidentKey!' unless incidentKey?

    @_request
      eventType: 'resolve'
      incidentKey: incidentKey
      details: details
      description: description
      cb: callback


  _request: ({description, incidentKey, eventType, details, cb}) ->
    incidentKey ||= null
    details     ||= {}
    cb          ||= ->

    json =
      service_key: @serviceKey
      event_type: eventType
      description: description
      details: details

    json.incident_key = incidentKey if incidentKey?

    request
      method: 'POST'
      uri: 'https://events.pagerduty.com/generic/2010-04-15/create_event.json'
      json: json
    , (err, response, body) ->
      if err or response.statusCode != 200
        cb err || new Error('PagerDuty._requestFailed: ' + response.statusCode)
      else
        cb null, body



