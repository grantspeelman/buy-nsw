(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function RemoveFileModule (options) {
    this.$container = options.$container
    this.$input = this.$container.find('input[type=checkbox]')
    this.$label = this.$container.find('label')
    this.$form = this.$container.parents('form')

    this.hideInput()
    this.buildButton()
  }

  RemoveFileModule.prototype.hideInput = function () {
    this.$container.addClass('js-enabled')
    this.$input.hide()
    this.$label.remove()
  }

  RemoveFileModule.prototype.buildButton = function () {
    var $button = $('<button></button>')
    var labelText = this.$label.text()

    $button.text(labelText)
    $button.on('click', $.proxy(this.removeFile, this))

    $button.appendTo(this.$container)
  }

  RemoveFileModule.prototype.removeFile = function (event) {
    event.preventDefault()

    window.console.dir(this.$form)

    this.$input.prop('checked', true)
    this.$form.submit()
  }

  window.ProcurementHub.RemoveFileModule = RemoveFileModule
}())

$(function () {
  $('*[data-module="remove-file"]').each(
    function (i, element) {
      // eslint-disable-next-line no-new
      new window.ProcurementHub.RemoveFileModule({
        $container: $(element)
      })
    }
  )
})
