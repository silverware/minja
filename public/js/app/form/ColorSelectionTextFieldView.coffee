App.ColorSelectionComponent = Ember.Component.extend
  name: ''
  value: null

  layout: Ember.Handlebars.compile """
    <div class="input-group color" data-color="{{unbound value}}" data-color-format="rgba">
      {{input class="form-control" value=value name=name}}
      <span class="input-group-addon"><i style="background-color: {{unbound value}}"></i></span>
    </div>
    """
  didInsertElement: ->
    @_super()
    @$(".color").colorpicker({place: "right"}).on "changeColor", ->
