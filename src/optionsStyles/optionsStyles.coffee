React = require '../reactGUI/React-shim'

optionsStyles = {}

defineOptionsStyle = (name, style) ->
  optionsStyles[name] = (props) -> React.createElement(style, props)

module.exports = {optionsStyles, defineOptionsStyle}