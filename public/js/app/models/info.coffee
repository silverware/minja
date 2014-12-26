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

  descriptionCompiled: (->
    marked @get 'description'
  ).property('description')

  prettyStartDateTime: (->
  
  ).property('startDate', 'startTime')
