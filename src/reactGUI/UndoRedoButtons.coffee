React = require './React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
createSetStateOnEventMixin = require './createSetStateOnEventMixin'
{classSet} = require '../core/util'
{_} = require '../core/localization'

createUndoRedoButtonComponent = (undoOrRedo) -> createReactClass
  displayName: if undoOrRedo == 'undo' then 'UndoButton' else 'RedoButton'
  getState: -> {
    isEnabled: switch
      when undoOrRedo == 'undo' then @props.lc.canUndo()
      when undoOrRedo == 'redo' then @props.lc.canRedo()
  }
  getInitialState: -> @getState()
  mixins: [createSetStateOnEventMixin('drawingChange')]
  render: ->
    {lc, imageURLPrefix} = @props
    title = if undoOrRedo == 'undo' then 'Undo' else 'Redo'
    title = _(title)
    className = "lc-#{undoOrRedo} " + classSet
      'toolbar-button': true
      'thin-button': true
      'disabled': not @state.isEnabled
    onClick = switch
      when !@state.isEnabled then ->
      when undoOrRedo == 'undo' then -> lc.undo()
      when undoOrRedo == 'redo' then -> lc.redo()
    src = "#{imageURLPrefix}/#{undoOrRedo}.png"
    style = {backgroundImage: "url(#{src})"}
    React.createElement 'div', {className, onClick, title, style}

# Use React.createElement instead of React.createFactory
UndoButton = (props) -> React.createElement(createUndoRedoButtonComponent('undo'), props)
RedoButton = (props) -> React.createElement(createUndoRedoButtonComponent('redo'), props)

UndoRedoButtons = createReactClass
  displayName: 'UndoRedoButtons'
  render: ->
    React.createElement 'div', {className: 'lc-undo-redo'}, UndoButton(@props), RedoButton(@props)

module.exports = UndoRedoButtons
