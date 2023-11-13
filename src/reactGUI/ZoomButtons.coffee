React = require './React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
createSetStateOnEventMixin = require './createSetStateOnEventMixin'
{classSet} = require '../core/util'
{_} = require '../core/localization'

createZoomButtonComponent = (inOrOut) -> createReactClass
  displayName: if inOrOut == 'in' then 'ZoomInButton' else 'ZoomOutButton'
  getState: -> {
    isEnabled: switch
      when inOrOut == 'in' then @props.lc.scale < @props.lc.config.zoomMax
      when inOrOut == 'out' then @props.lc.scale > @props.lc.config.zoomMin
  }
  getInitialState: -> @getState()
  mixins: [createSetStateOnEventMixin('zoom')]
  render: ->
    {lc, imageURLPrefix} = @props
    title = if inOrOut == 'in' then 'Zoom in' else 'Zoom out'
    title = _(title)
    className = "lc-zoom-#{inOrOut} " + classSet
      'toolbar-button': true
      'thin-button': true
      'disabled': not @state.isEnabled
    onClick = switch
      when !@state.isEnabled then ->
      when inOrOut == 'in' then -> lc.zoom(lc.config.zoomStep)
      when inOrOut == 'out' then -> lc.zoom(-lc.config.zoomStep)
    src = "#{imageURLPrefix}/zoom-#{inOrOut}.png"
    style = {backgroundImage: "url(#{src})"}

    # Use React.createElement instead of DOM.div
    React.createElement 'div', {className, onClick, title, style}

# Create ZoomButton elements directly with React.createElement
ZoomOutButton = (props) -> React.createElement(createZoomButtonComponent('out'), props)
ZoomInButton = (props) -> React.createElement(createZoomButtonComponent('in'), props)

ZoomButtons = createReactClass
  displayName: 'ZoomButtons'
  render: ->
    # Use React.createElement instead of DOM.div
    React.createElement 'div', {className: 'lc-zoom'},
      ZoomOutButton(@props),
      ZoomInButton(@props)

module.exports = ZoomButtons