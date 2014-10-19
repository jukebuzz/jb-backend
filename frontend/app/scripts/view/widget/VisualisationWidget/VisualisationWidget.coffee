define (require, exports, module)->
  _Widget = require "../_Widget"
  Backbone = require "backbone"
  ScreenSketch = require "utils/sketch"
  audio = require "utils/audio"
  common = require "common"
  TrackModel = require "model/TrackModel"

  ViewModel = Backbone.Epoxy.Model.extend
    defaults:
      mousemove: false

  VisualisationWidget = _Widget.extend
    template: "#VisualisationWidget"
    className: "visualisation_widget"
    ui:
      "close": "[data-js-close]"
      "artist": "[data-js-artist]"
      "title": "[data-js-title]"

    bindings:
      '@ui.title': 'text: title'
      '@ui.artist': 'text: artist'

    events:
      "click @ui.close": "onClickClose"

    initialize: ->
      @collection = common.trackCollection
      @model = new TrackModel

    setRoom: (@room_id)->

    onShow: ->
      $(document).on "keydown", @onKeyPress
      audio.done (player)=>
        @player = player
        @startPlay()
        @player.on 'ended', =>
          common.api.post_playlist_id_next(@room_id).done (data)=>
            @collection.setData data
          @startPlay()

    startPlay: ->
      return if @collection.length is 0
      model = @collection.at(0)
      @model.set model.toJSON()
      url = (model.get 'stream_url') + '?client_id=e90b73852966e0f8a83b4c4e39d90ab5'
      if @screen?
        @screen.kill()
        @screen = null
      @player.pause()
      _.delay =>
        @player.load url
        @screen = new ScreenSketch @$el[0], @player.audio.audio
      , 50
      # _.delay =>
        # @player.play()
      # , 100


    onClickClose: ->
      Backbone.trigger "vis:toggle", false

    onClose: ->
      $(document).off "keydown", @onKeyPress
      audio.done (@player)=>
        player.off 'ended'
        # if player.playing
        # player.pause()
        if @screen?
          @screen.kill()
          @screen = null

    onKeyPress: (e)->
      Backbone.trigger "vis:toggle", false if e.keyCode is 27

