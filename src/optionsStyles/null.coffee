React = require '../reactGUI/React-shim'
createReactClass = require '../reactGUI/createReactClass-shim'
{defineOptionsStyle} = require './optionsStyles'

defineOptionsStyle 'null', createReactClass
  displayName: 'NoOptions'
  render: ->
    e = React.createElement
    e 'div', {}

module.exports = {}
