React = require '../reactGUI/React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
{defineOptionsStyle} = require './optionsStyles'
StrokeWidthPicker = require '../reactGUI/StrokeWidthPicker'
createSetStateOnEventMixin = require '../reactGUI/createSetStateOnEventMixin'
{classSet} = require '../core/util'

defineOptionsStyle 'line-options-and-stroke-width', createReactClass
  displayName: 'LineOptionsAndStrokeWidth'
  getState: -> {
    strokeWidth: @props.tool.strokeWidth,
    isDashed: @props.tool.isDashed,
    hasEndArrow: @props.tool.hasEndArrow,
  }
  getInitialState: -> @getState()
  mixins: [createSetStateOnEventMixin('toolChange')]

  render: ->
    e = React.createElement
    toggleIsDashed = =>
      @props.tool.isDashed = !@props.tool.isDashed
      @setState @getState()
    toggleHasEndArrow = =>
      @props.tool.hasEndArrow = !@props.tool.hasEndArrow
      @setState @getState()

    dashButtonClass = classSet
      'square-toolbar-button': true
      'selected': @state.isDashed
    arrowButtonClass = classSet
      'square-toolbar-button': true
      'selected': @state.hasEndArrow
    style = {float: 'left', margin: 1}

    e 'div', {},
      [
        e 'div', {className: dashButtonClass, onClick: toggleIsDashed, style},
          [
            e 'img', {src: "#{@props.imageURLPrefix}/dashed-line.png"}
          ],
        e 'div', {className: arrowButtonClass, onClick: toggleHasEndArrow, style},
          [
            e 'img', {src: "#{@props.imageURLPrefix}/line-with-arrow.png"}
          ],
        e(StrokeWidthPicker, {tool: @props.tool, lc: @props.lc})
      ]

module.exports = {}
