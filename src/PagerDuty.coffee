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
    throw new Error 'PagerDuty.resolve: Need incidentKey!' unless incidentKey?

    @_request arguments[0] extends eventType: 'resolve'

  _request: ({description, incidentKey, eventType, details, callback}) ->
    throw new Error 'PagerDuty._request: Need eventType!' unless eventType?

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

  createUser: ({subdomain, name, email, requester_id, callback}) ->

    callback    ||= ->

    json =
      name: name
      email: email
      requester_id: requester_id

    uri = 'https://' + subdomain + '.pagerduty.com/api/v1/users'

    request
      method: 'POST'
      uri: uri
      json: json
      headers: { 'Authorization': 'Token token=' + @serviceKey }
    , (err, response, body) ->
      if err or response.statusCode != 201
        # FIXME for e.g. 401 this causes an error, since body won't
        # have anything useful in it
        callback err || new Error(body.error.errors[0])
      else
        callback null, body

  createService: ({subdomain, token, name, escalation_policy_id, type, callback}) ->

    callback    ||= ->

    json =
      name: name
      escalation_policy_id: escalation_policy_id
      type: type

    uri = 'https://' + subdomain + '.pagerduty.com/api/v1/services'

    request
      method: 'POST'
      uri: uri
      json: json
      headers: { 'Authorization': 'Token token=' + @serviceKey }
    , (err, response, body) ->
      if err or response.statusCode != 201
        # FIXME for e.g. 401 this causes an error, since body won't
        # have anything useful in it
        callback err || new Error(body.error.errors[0])
      else
        callback null, body
