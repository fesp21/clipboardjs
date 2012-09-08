class Modal
  @ERROR = "error"
  @SUCCESS = "success"

  constructor: (@template, @validator = null) ->
    @_modal = null

  _validate: (event) =>
    if @validator isnt null
      isValid = @validator.validate event.target.name, event.target.value
  
      state = if isValid then Modal.SUCCESS else Modal.ERROR
      state = "" if isValid is null
  
      $(event.target).parents('.control-group:first').removeClass("#{Modal.ERROR} #{Modal.SUCCESS}").addClass(state)
      @_updateButtonState()
    
  _updateButtonState: ->
    if @_modal?.find(".error").length > 0
      @_modal.find(".save").attr("disabled", "disabled")
    else
      @_modal?.find(".save").removeAttr("disabled")

  _submitHandler: (event) =>
    data = {}
    @_modal.find('input').each(->
      data[this.name] = if this.type is "checkbox" then this.checked else this.value
    )
    @submit data

  _closeModal: () =>
    @_modal?.remove()

  show: (templateData = {}) ->
    @_modal = $ @template(templateData)
    @_modal.appendTo 'body'

    @_modal.on "click", "button.save:not(:disabled)", @_submitHandler
    @_modal.on "click", ".cancel, .close", @_closeModal
    @_modal.on "keyup", "input", @_validate

    @_modal.find('input').trigger "keyup"
    @_modal.removeClass "hide fade"
    @_modal.find('input:first').trigger "focus"

  close: ->
    @_closeModal()
  submit: (data) ->
    console.log "submitted #{data}"
    
    