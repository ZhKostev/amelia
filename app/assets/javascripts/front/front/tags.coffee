# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class @TagShow
  @init: (tagSearchId) =>
    App.TagSearchChannel = App.cable.subscriptions.create { channel: "TagSearchChannel", tag_search_id: tagSearchId },
      received: (data) ->
        console.log(data)

