request = require 'request'

class PagerDuty
  module.exports = PagerDuty

  constructor: ({@serviceKey}) ->
    throw new Error 'PagerDuty.constructor: Need serviceKey!' unless @serviceKey?

  create: ({description, incidentKey, details, callback}) ->
    throw new Error 'PagerDuty.create: Need description!' unless description?

    @_request arguments[0] extends eventType: 'trigger'

  acknowledge: ({incidentKey, details, description, callback}) ->
    throw new Error 'PagerDuty.acknowledge: Need incidentKey!' unless incidentKey?

    @_request arguments[0] extends eventType: 'acknowledge'

  resolve: ({incidentKey, details, description, callback}) ->
    throw new Eror 'PagerDuty.resolve: Need incidentKey!' unless incidentKey?

    @_request arguments[0] extends eventType: 'resolve'

  _request: ({description, incidentKey, eventType, details, callback}) ->
    throw new Eror 'PagerDuty._request: Need eventType!' unless eventType?

    incidentKey ||= null
    details     ||= {}
    callback    ||= ->

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
        callback err || new Error(body.errors[0])
      else
        callback null, body



