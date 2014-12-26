App.SaveButtonComponent = Ember.Component.extend
  label: ''

  layout: Ember.Handlebars.compile """
        <div class="form-group">
          <div class="col-sm-offset-2 col-sm-10">
            <button class="btn btn-inverse" type="submit">{{label}}</button>
            <i class="fa fa-spinner fa-spin ajaxLoader"></i>
            <span class="successIcon"><i class="fa fa-check"></i> {{savedLabel}}</span>
          </div>
        </div>
    """
  didInsertElement: ->
    @_super()

  savedLabel: (->
    App.i18n.saved
  ).property()
