Template.messages_list.are_messages_available = ->
  Messages.find({board_id: Session.get(SESSION_BOARD_ID)}).count() > 0
  
Template.messages_list.messages = ->
  Messages.find({board_id: Session.get(SESSION_BOARD_ID)},
    {sort:
      {time: -1}
    }).fetch().slice(0, 10)

Template.messages_list.board = ->
  board_name: Session.get SESSION_BOARD_TITLE
  board_id: Session.get SESSION_BOARD_ID
  is_active: Session.get(SESSION_MESSAGE_ID) is ""
  
Template.message_abstr.is_active = (id)->
  id is Session.get SESSION_MESSAGE_ID
  
Template.message_view.is_authorized = ->
  messagesController.canViewMessage(Session.get(SESSION_USER), Session.get(SESSION_MESSAGE_ID))


Template.message_view.show = ->
  messageId = Session.get(SESSION_MESSAGE_ID)
  isRightState = appState.getState() is appState.MESSAGE
  isMessageSelected = messageId isnt ""

  isRightState and isMessageSelected

Template.message_view.board_name = (boardId) ->
  Boards.findOne(boardId)?.title

Template.message_view.message = ->
  Messages.findOne Session.get(SESSION_MESSAGE_ID)

Template.message_view.prettyprint = ->
  uuid = Meteor.uuid()
  messagesController.getHighlightedMessage(Session.get(SESSION_MESSAGE_ID), (message) ->
    $('#' + uuid).html(message).removeClass("loading")
  )
  uuid

Template.message_view.events =
  "click .raw": (evt) ->
    messagesController.getRawMessage(Session.get(SESSION_MESSAGE_ID), (message) ->
      raw = $ Template.message_raw({message: message})
      $('body').append(raw)
      $('body').children('.app').hide()
      
      $('.raw-file .close').click(->
        raw.remove()
        $('body').children('.app').show()
      )
    )
    

  "click .prettyprint code": (evt) ->
    if document.selection
      range = document.body.createTextRange()
      range.moveToElementText(evt.currentTarget)
      range.select()
    else if window.getSelection
      range = document.createRange()
      range.selectNode(evt.currentTarget)
      window.getSelection().addRange(range)