request = require 'request'

class PagerDuty
  module.exports = PagerDuty

  constructor: (@serviceKey) ->
    throw new Error 'PagerDuty.constructor: Need serviceKey!' unless @serviceKey?

  create: (description, {incidentKey, details, cb}) ->
    throw new Error 'PagerDuty.create: Need description!' unless description?

    @_request
      eventType: 'trigger'
      description: description
      incidentKey: incidentKey
      details: details
      cb: cb


  acknowledge: (incidentKey, {details, description, cb}) ->
    throw new Error 'PagerDuty.acknowledge: Need acknowledge!' unless incidentKey?

    @_request
      eventType: 'acknowledge'
      incidentKey: incidentKey
      details: details
      description: description
      cb: cb


  resolve: (incidentKey, {details, description, cb}) ->
    throw new Eror 'PagerDuty.resolve: Need incidentKey!' unless incidentKey?

    @_request
      eventType: 'resolve'
      incidentKey: incidentKey
      details: details
      description: description
      cb: cb


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



