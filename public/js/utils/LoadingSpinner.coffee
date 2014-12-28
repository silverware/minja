App.LoadingSpinner = Ember.Object.extend
  loaded: 0
  total: 100
  lastPicked: [ "grey" , "grey" , "grey" ]
  colors: [
    "red"
    "green"
    "blue"
    "yellow"
    "purple"
  ]
  
  start: ->
    @.getElements()
    @.addListeners()
    
  getElements: ->
    @.el = document.getElementsByClassName("loader")[0]
    
  addListeners: ->
    @.loadSim = setInterval =>
      @.loaded += 1 + Math.floor( Math.random() * 5 )
    , 200
    
    @.loadCheck = setInterval =>
      if @.loaded < @.total
        @.addBanner()
      else
        clearInterval( @.loadSim )
        clearInterval( @.loadCheck )
    , 200
    
  addBanner: =>
    banner = document.createElement("i")
    color = @.lastPicked[0]
    while @.lastPicked.indexOf( color ) isnt -1
      color = @.colors[ Math.floor( Math.random() * @.colors.length)]
    @.lastPicked.unshift( color )
    @.lastPicked.pop()
    
    banner.setAttribute( "class" , color )
    @.el.insertBefore( banner , @.el.children[0] )
    
    while @.el.children.length > 12
      @.el.removeChild( @.el.children[12] )
    
# App = new Loader
# App.start()
