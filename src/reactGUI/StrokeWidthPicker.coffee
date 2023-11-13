React = require './React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
createSetStateOnEventMixin = require '../reactGUI/createSetStateOnEventMixin'
{classSet} = require '../core/util'

module.exports = createReactClass
  displayName: 'StrokeWidthPicker'

  getState: (tool=@props.tool) -> {strokeWidth: tool.strokeWidth}
  getInitialState: -> @getState()
  mixins: [createSetStateOnEventMixin('toolDidUpdateOptions')]

  componentWillReceiveProps: (props) -> @setState @getState(props.tool)

  render: ->
    strokeWidths = @props.lc.opts.strokeWidths

    React.createElement 'div', {},
      strokeWidths.map (strokeWidth, ix) =>
        buttonClassName = classSet
          'square-toolbar-button': true
          'selected': strokeWidth == @state.strokeWidth
        buttonSize = 28

        buttonProps = {
          key: strokeWidth,
          className: buttonClassName,
          onClick: => @props.lc.trigger 'setStrokeWidth', strokeWidth
        }

        circleProps = {
          cx: Math.ceil(buttonSize/2-1),
          cy: Math.ceil(buttonSize/2-1),
          r: strokeWidth/2
        }

        svgProps = {
          width: buttonSize-2,
          height: buttonSize-2,
          viewport: "0 0 #{strokeWidth} #{strokeWidth}",
          version: "1.1",
          xmlns: "http://www.w3.org/2000/svg"
        }

        React.createElement 'div', {key: strokeWidth},
          React.createElement 'div', buttonProps,
            React.createElement 'svg', svgProps,
              React.createElement 'circle', circleProps
