React = require '../reactGUI/React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
createSetStateOnEventMixin = require './createSetStateOnEventMixin'
{_} = require '../core/localization'
{classSet} = require '../core/util'

ClearButton = createReactClass
  displayName: 'ClearButton'
  getState: -> {isEnabled: @props.lc.canUndo()}
  getInitialState: -> @getState()
  mixins: [createSetStateOnEventMixin('drawingChange')]

  render: ->
    e = React.createElement 
    {lc} = @props

    className = classSet
      'lc-clear': true
      'toolbar-button': true
      'fat-button': true
      'disabled': not @state.isEnabled
    onClick = if lc.canUndo() then (=> lc.clear()) else ->

    e('div', {className, onClick}, _('Clear'))


module.exports = ClearButton
