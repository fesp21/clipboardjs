do ->
  shareModal = new Modal(Template.share_message_modal)
  
  Template.message_view.show = ->
    messageId = Session.get(SESSION_SHORT_MESSAGE_ID)
    isRightState = appState.getState() is appState.MESSAGE
    isMessageSelected = messageId isnt ""
  
    isRightState and isMessageSelected
  
  Template.message_view.message = ->
    Messages.findOne({short_id: Session.get(SESSION_SHORT_MESSAGE_ID)})
    
  Template.message_view.is_bookmarked = (messageId) ->
    userId = Session.get SESSION_USER
    Messages.find({_id: messageId, bookmarked_by: userId}).count() > 0
    
  Template.message_view.rendered = ->
    
    view = this.find '.message-view'
    $('.tooltip').remove()
    $(this.findAll('.message-actions .btn')).tooltip()
    messageId = Session.get(SESSION_SHORT_MESSAGE_ID)
  
    if view
      Meteor.call "getMessage", messageId, Session.get(SESSION_USER), (err, message) =>
        view.className = "message-view"
        if typeof err is "undefined"
          view.innerHTML = Template.message_detail(message)
        else
          console.log err
          view.innerHTML = Template.message_detail_unavailable()
  
  Template.message_view.events =
    'click .share' : (evt) ->
      url = window.location
      shareModal.show {url:url}
      
    "click .raw": (evt) ->
      messagesController.getRawMessage(Session.get(SESSION_SHORT_MESSAGE_ID), (message) ->
        raw = $ Template.message_raw({message: message})
        $('body').append(raw)
        $('body').children('.app').hide()
  
        $('.raw-file .close').click(->
          raw.remove()
          $('body').children('.app').show()
        )
      )
  
    'click .add-bookmark': (evt) ->
      messageId = Session.get SESSION_SHORT_MESSAGE_ID
      messagesController.addBookmark messageId
      
    'click .remove-bookmark': (evt) ->
      messageId = Session.get SESSION_SHORT_MESSAGE_ID
      messagesController.deleteBookmark messageId
  
    "click .prettyprint code": (evt) ->
      if document.selection
        range = document.body.createTextRange()
        range.moveToElementText(evt.currentTarget)
        range.select()
      else if window.getSelection
        range = document.createRange()
        range.selectNode(evt.currentTarget)
        window.getSelection().addRange(range)