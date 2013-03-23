class App.Alert
  
  @open: (title, text) ->
    $(".alert").alert('close')
    $("body").append(App.Alert.template.replace("###text###", text).replace("###title###", title))
    

  @openWarning: (text) ->
    App.Alert.open("Warning!", text)

  @template = """
    <div class="alert alert-block" style="position: fixed; top: 40px;">
    <button class="close" data-dismiss="alert" type="button">×</button>
    <h4 class="alert-heading">###title###</h4>
    ###text###
    </div>
    """