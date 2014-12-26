App.templates.dashboard = """
<div class="container dashboard">
<div class="row">
<div class="col-md-6">
  {{#link-to 'info'}}
  <section class="dashboardBox dashboardLightning">
    <fieldset>
    <legend>{{i18n.info.basicData}}</legend>
    <dl class="dl-horizontal" style="margin-top: 0px">
      <dt><i class="fa fa-calendar"></i></dt>
      <dd>
        {{pretty-date-time date=info.startDate time=info.startTime}}
      </dd>
      <dt><i class="fa fa-map-marker"></i></dt>
      <dd>{{info.venue}}
    </dl>
    <dl class="dl-horizontal">
      <dt><i class="fa fa-user"></i></dt>
      <dd>{{info.host}}</dd>
      <dt>E-Mail</dt>
      <dd>{{info.hostMail}}
    </dl>
    </fieldset>
  </section>
  {{/link-to}}


  {{#link-to 'chat'}}
<section id="messageDashboardBox" class="dashboardBox dashboardLightning">
  <fieldset>
  <legend>{{i18n.chat.messageStream}}</legend>
    <center class="spinner-wrapper"><i class="fa fa-spinner fa-spin"></i></center>
    <div id="chat"></div>
  </fieldset>
</section>
  {{/link-to}}
</div>


<div class="col-md-6">

  {{#link-to 'participants'}}
<section class="dashboardBox dashboardLightning">
  <fieldset>
    <legend>{{i18n.members.navName}}</legend>
    {{#each member in participants.players}}
      <span class="label" style="display: inline-block">{{member.name}}</span>
      {{/each}}
    <div class="bottomRight">
      <em>{{participantCount}} {{i18n.members.navName}}</em>
    </div>
    </span>
  </fieldset>
</section>
  {{/link-to}}

  {{#link-to 'bracket'}}
    <section class="dashboardBox dashboardLightning" id="treeDashboardBox">
      <fieldset>
        <legend>{{i18n.bracket.navName}}</legend>
        {{view 'bracketStatistics'}}
      </fieldset>
    </section>
  {{/link-to}}

</div>
</div>
</div>
"""

App.DashboardView = Em.View.extend
  template: Ember.Handlebars.compile App.templates.dashboard

  didInsertElement: ->
    @_super()
    # Chat.create({
    #   tournament_id: "<%= @tournament.id %>",
    #   editable: false,
    #   i18n: <%- @json @i18n.chat %>,
    #   limit: 2
    # App.TreeStatisticsView.init()

