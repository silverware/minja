App.ColorSelectionTextField = Ember.TextField.extend
  name: ''
  classNames: ['form-control']
  type: 'text'

  layout: Ember.handlebars.compile """
    <div class="input-group color" id="colorpickername" data-color="<%= @val %>" data-color-format="rgba">
      {{yield}}
      <span class="input-group-addon"><i style="background-color: <%= @val %>"></i></span>
    </div>
    """
  didInsertElement: ->
    @_super()
    # $("#colorpicker<%= @name %>").colorpicker({place: "right"}).on("changeColor", function(event) {
