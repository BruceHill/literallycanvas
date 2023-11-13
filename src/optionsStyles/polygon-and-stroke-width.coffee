React = require '../reactGUI/React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
{defineOptionsStyle} = require './optionsStyles'
StrokeWidthPicker = require '../reactGUI/StrokeWidthPicker'
createSetStateOnEventMixin = require '../reactGUI/createSetStateOnEventMixin'

defineOptionsStyle 'polygon-and-stroke-width', createReactClass
  displayName: 'PolygonAndStrokeWidth'
  getState: -> {
    strokeWidth: @props.tool.strokeWidth
    inProgress: false
  }
  getInitialState: -> @getState()
  mixins: [createSetStateOnEventMixin('toolChange')]

  componentDidMount: ->
    unsubscribeFuncs = []
    @unsubscribe = =>
      for func in unsubscribeFuncs
        func()

    showPolygonTools = () =>
      @setState({ inProgress: true }) unless @state.inProgress

    hidePolygonTools = () =>
      @setState({ inProgress: false })

    unsubscribeFuncs.push @props.lc.on 'lc-polygon-started', showPolygonTools
    unsubscribeFuncs.push @props.lc.on 'lc-polygon-stopped', hidePolygonTools

  componentWillUnmount: ->
    @unsubscribe()

  render: ->
    e = React.createElement  # Shortcut for createElement
    lc = @props.lc

    polygonFinishOpen = () =>
      lc.trigger 'lc-polygon-finishopen'

    polygonFinishClosed = () =>
      lc.trigger 'lc-polygon-finishclosed'

    polygonCancel = () =>
      lc.trigger 'lc-polygon-cancel'

    polygonToolStyle = {}
    polygonToolStyle = {display: 'none'} unless @state.inProgress

    e 'div', {},
      [
        e 'div', {className: 'polygon-toolbar horz-toolbar', style: polygonToolStyle},
        [
          e 'div', {className: 'square-toolbar-button', onClick: polygonFinishOpen},
          [
            e 'img', {src: "#{@props.imageURLPrefix}/polygon-open.png"}
          ],
          e 'div', {className: 'square-toolbar-button', onClick: polygonFinishClosed},
          [
            e 'img', {src: "#{@props.imageURLPrefix}/polygon-closed.png"}
          ],
          e 'div', {className: 'square-toolbar-button', onClick: polygonCancel},
          [
            e 'img', {src: "#{@props.imageURLPrefix}/polygon-cancel.png"}
          ]
        ],
        e 'div', {},
        [
          React.createElement(StrokeWidthPicker, {tool: @props.tool, lc: @props.lc})
        ]
      ]


module.exports = {}
