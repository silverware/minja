App.FormGroupComponent = Ember.Component.extend
  label: ""
  name: ""
  layout: Ember.Handlebars.compile """
    <div class="form-group">
      <label class="col-sm-2 control-label" for="input{{unbound name}}">{{label}}</label>
      <div class="col-sm-10">
        {{yield}}
      </div>
    </div>
  """
