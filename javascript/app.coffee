# Build a single-page browser app that displays a list of Happify challenges and, 
# once a user selects a challenge, allows them to select an activity to do in that challenge.
# Build a Backbone.js client application given 2 mock Happify API endpoints:
# http://happify-test-api.herokuapp.com/api/challenges
# http://happify-test-api.herokuapp.com/api/challenges/:challenge_id

(($) ->
  
  # View - challenges/
  IndexView = Backbone.View.extend(
    data: null
    events:
      "click button": "challengeClicked"

    initialize: (options) ->
      @data = options.data

    render: ->
      html = ""
      i = 0
      while i < @data.length
        html += "<div><button class='challenge' id='" + @data[i].id + "'>" + @data[i].name + "</button></div>"
        i++
      @$el.html html

    challengeClicked: (e) ->
      app.navigate "challenges/" + arguments[0].currentTarget.id,
        trigger: true

  )
  
  # View - challenges/:id
  PageView = Backbone.View.extend(
    data: null
    events:
      "click .activity": "activityClicked"

    initialize: (options) ->
      @data = options.data

    render: ->
      html = "<h3>" + @data.name + "</h3>Activities:<ul>"
      i = 0

      while i < @data.activities.length
        html += "<div><a class='activity' id=" + @data.activities[i].id + ">" + @data.activities[i].name + "</a></div>"
        i++
      html+="</ul>"
      @$el.html html

    activityClicked: (e) ->
      app.navigate "activities/" + arguments[0].currentTarget.id,
        trigger: true
  )
  
  # View - activity/:id ... we'll want to build this out
  ActivityView = Backbone.View.extend(
    id: null

    initialize: (options) ->
      @id = options.id

    render: ->
      html = "<div>" + @id + "</div>"
      @$el.html html
  )

  # Router
  happifyStarterApp = Backbone.Router.extend(
    happifyUrl: "http://happify-test-api.herokuapp.com/api/"
    routes:
      "": "listChallengesAction"
      "challenges/:challenge": "challengeAction"
      "activities/:activities": "activitiesAction"

    challengeAction: (id) ->
      url = @happifyUrl + "challenges/" + id
      @loadChallengeData url

    listChallengesAction: ->
      url = @happifyUrl + "challenges"
      @loadChallengesList url

    activitiesAction: (id) ->
      @loadActivitiesData id

    # adds header and gets data for challenges/
    loadChallengesList: (pageUrl) ->
      $("#menu").html "<h1>Ghan Test Happify App</h2>"
      
      $.ajax
        url: pageUrl
        dataType: "json"
        success: (data) ->
          if data
            @pageView_.remove()  if @pageView_
            @pageView_ = new IndexView(data: data)
            @pageView_.render()
            @pageView_.$el.appendTo "#menu"
          else
            $("#menu").html "<h1>Error! Couldn't fetch data</h2>"

        error: (request, status, error) ->
          $("#menu").html "<h1>Error! Couldn't fetch data</h2>"

    # Gets data for challenges/id
    loadChallengeData: (pageUrl) ->
      $.ajax
        url: pageUrl
        dataType: "json"
        success: (data) ->
          $("#content-pane").html ""
          @pageView_.remove()  if @pageView_
          @pageView_ = new PageView(data: data)
          @pageView_.render()
          @pageView_.$el.appendTo "#content-pane"

    # Passes activity id to view... eventually we'll want more data here
    loadActivitiesData: (id) ->
      console.log "activity: " + id
     	$("#content-pane").html ""
      @pageView_.remove()  if @pageView_
      @pageView_ = new ActivityView(id: id)
      @pageView_.render()
      @pageView_.$el.appendTo "#content-pane"
  )

  app = undefined
  $ ->
    app = new happifyStarterApp
    Backbone.history.start()

) jQuery
