crypto = require 'crypto'

class UserDao extends require('./DaoBase')

  testdata: => [
    {email: "test@example.com", password: @hashPassword("test")}
  ]

  secretKey = '^#1256oknbfxo0987j6@#$%^&*(hnygfde67ui987'
  hashAlgorithm = 'sha1'

  hashPassword: (string) ->
    hash = crypto.createHash hashAlgorithm
    hash.update(string).digest('hex')

  constructor: ->
    super 'users'

  initialize: ->
    @db.save '_design/user',
      views:
        byEmail:
          map: 'function(doc) { emit(doc.email, doc) }'


  generateSecretHash: ->
    plain = (@generatePassword() for i in [1..5])
    plain = plain.join ''
    @hashPassword plain

  generatePassword: ->
    vocals = ['a', 'e', 'i', 'o', 'u']
    consonants = ['b', 'c', 'd', 'f', 'g', 'h', 'k', 'm', 'p', 'r', 's', 't', 'v', 'w', 'z']
    misc = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '!', '@', '#']

    length = Math.floor(Math.random()*6)+5
    password = []
    needConsonant = true
    randomIndex = (maxIndex) => Math.floor(Math.random()*maxIndex)
    for x in [1..length]
      if needConsonant
        index = randomIndex(consonants.length-1)
        char = consonants[index]
      else
        index = randomIndex(vocals.length-1)
        char = vocals[index]

      password.push(char)
      needConsonant = if needConsonant then false else true

    length = Math.floor(Math.random()*3)+2
    for x in [1..length]
      password.push(misc[randomIndex(misc.length-1)])

    return password.join ''
  
  create: (email, password, callback) ->
    email = email.toLowerCase()
    user =
      email: email
    if password
      user.password = @hashPassword password
    @save user, callback

  validPassword: (user, pass) ->
    shasum = crypto.createHash 'sha1'
    hash = shasum.update(pass).digest 'hex'
    user.password == hash

  findOrCreateByEmail: (email, callback) ->
    email = email.toLowerCase()
    @findByEmail email, (user) =>
      if not user
        @create email, null, (res, err) ->
          if err then callback err, null else callback null, res
      else
        callback null, user

  findByEmail: (email, callback) ->
    email = email.toLowerCase()
    @db.view 'user/byEmail', key: email, (err, users) ->
      if users? and users.length > 0
        callback users[0].value
      else
        callback null, err

module.exports = new UserDao()
