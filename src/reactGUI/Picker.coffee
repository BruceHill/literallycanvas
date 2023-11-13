React = require './React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'

# Import components and use them directly
ClearButton = require './ClearButton'
UndoRedoButtons = require './UndoRedoButtons'
ZoomButtons = require './ZoomButtons'

{_} = require '../core/localization'
ColorWell = require './ColorWell'

# Refactor ColorPickers to use React.createElement
ColorPickers = createReactClass
  displayName: 'ColorPickers'
  render: ->
    {lc} = @props
    React.createElement('div', {className: 'lc-color-pickers'},
      React.createElement(ColorWell, {lc, id:"primary", colorName: 'primary', label: _('stroke')}),
      React.createElement(ColorWell, {lc, id:"secondary", colorName: 'secondary', label: _('fill')}),
      React.createElement(ColorWell, {lc, id:"background", colorName: 'background', label: _('bg')})
    )

# Refactor Picker to use React.createElement
Picker = createReactClass
  displayName: 'Picker'
  getInitialState: -> {selectedToolIndex: 0}
  renderBody: ->
    {toolButtonComponents, lc, imageURLPrefix} = @props
    buttons = toolButtonComponents.map((Component, ix) =>
      React.createElement(Component,
        {
          lc, imageURLPrefix,
          key: ix,
          isSelected: ix == @state.selectedToolIndex,
          onSelect: (tool) =>
            lc.setTool(tool)
            @setState({selectedToolIndex: ix})
        }
      )
    )
    # Add a spacer if the number of tools is odd
    if toolButtonComponents.length % 2 != 0
      buttons.push React.createElement('div', {key: "spacer", className: 'toolbar-button thin-button disabled'})

    React.createElement('div', {className: 'lc-picker-contents'},
      buttons,
      React.createElement('div', {style: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
      }},
        React.createElement(ColorPickers, {lc}),
        React.createElement(UndoRedoButtons, {lc, imageURLPrefix}),
        React.createElement(ZoomButtons, {lc, imageURLPrefix}),
        React.createElement(ClearButton, {lc})
      )
    )
  render: ->
    React.createElement('div', {className: 'lc-picker'},
      this.renderBody()
    )

module.exports = Picker