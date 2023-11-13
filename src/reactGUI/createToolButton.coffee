React = require './React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
{classSet} = require '../core/util'
{_} = require '../core/localization'

createToolButton = (tool) ->
  displayName = tool.name
  imageName = tool.iconName
  return createReactClass
    displayName: displayName,
    getDefaultProps: -> {isSelected: false, lc: null}
    componentWillMount: ->
      if @props.isSelected
        @props.lc.setTool(tool)
    render: ->
      {imageURLPrefix, isSelected, onSelect} = @props
      className = classSet
        'lc-pick-tool': true
        'toolbar-button': true
        'thin-button': true
        'selected': isSelected
      src = "#{imageURLPrefix}/#{imageName}.png"
      React.createElement('div', {
        className: className,
        style: {'backgroundImage': "url(#{src})"},
        onClick: (-> onSelect(tool)), 
        title: _(displayName)
      })

module.exports = createToolButton

