React = require './React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
createSetStateOnEventMixin = require './createSetStateOnEventMixin'
{optionsStyles} = require '../optionsStyles/optionsStyles'


Options = createReactClass
  displayName: 'Options'
  getState: -> {
    style: @props.lc.tool?.optionsStyle
    tool: @props.lc.tool
  }
  getInitialState: -> @getState()
  mixins: [createSetStateOnEventMixin('toolChange')]

  renderBody: ->
    # style can be null; cast it as a string
    style = "" + @state.style
    optionsComponent = optionsStyles[style]
    if optionsComponent
      React.createElement(optionsComponent, {
        lc: @props.lc, tool: @state.tool, imageURLPrefix: @props.imageURLPrefix
      })
    else
      null

  render: ->
    React.createElement('div', {className: 'lc-options horz-toolbar'},
      this.renderBody()
    )

module.exports = Options
