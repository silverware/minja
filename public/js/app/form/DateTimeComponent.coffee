App.DateTimeComponent = Ember.Component.extend
  name: ''
  value: null
  isDate: false
  isTime: false

  layout: Ember.Handlebars.compile """
    <div class='input-group col-sm-3 date'>
      {{input name=name value=value class="form-control"}} 
        <span class="input-group-addon"><i class="fa fa-{{unbound icon}}"></i></span>
      </div>
    """

  icon: (->
    if @isDate
      return 'calendar'
    if @isTime
      return 'clock-o'
  ).property()

  didInsertElement: ->
    @_super()
    if @isDate
      @$(".date").datetimepicker
        pickTime: false
        format: "DD.MM.YYYY"

      @$('.date').on "dp.change", (e) =>
        @set 'value', e.date.format "DD.MM.YYYY"

    if @isTime
      @$(".date").datetimepicker
        format: "HH:mm"
        pickDate: false
        defaultTime: false

      @$('.date').on "dp.change", (e) =>
        @set 'value', e.date.format "HH:mm"
