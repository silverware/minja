
authorTypes:
  leader: "leader"
  guest: "guest"

messageSchema =
  title: 'Message'
  type: 'object'
  properties:
    tournament_id:
      type: 'string'
    author:
      type: 'string'
    authorType:
      enum: [authorTypes.leader, authorTypes.guest]
    text:
      type: 'string'
  required: ['email']


class Message extends require './mixIn'
  tournament_id: ""
  author: ""
  authorType: ""
  text: ""

module.exports = Message
