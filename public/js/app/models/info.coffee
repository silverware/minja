App.Info = Em.Object.extend
  name: ''
  description: ''
  startDate: ''
  stopDate: ''
  startTime: ''
  stopTime: ''
  venue: ''
  host: ''
  hostMail: ''

  isEmpty: (->
    if @get('description') or @get('startDate') or @get('venue') or @get('host') or @get('hostMail')
      return false
    return true
  ).property('description', 'startDate', 'venue', 'host', 'hostMail')
