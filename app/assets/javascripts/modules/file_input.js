(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function FileInputModule (options) {
    this.el = options.el
    this.$el = $(this.el)
    this.$button = this.$el.closest('form').find('input[type=submit]')
    this.updatedText = 'Save and upload document'

    this.bindEvents()
  }

  FileInputModule.prototype.bindEvents = function () {
    this.$el.on('change', $.proxy(this.updateButtonText, this))
  }

  FileInputModule.prototype.updateButtonText = function () {
    this.$button.val(this.updatedText).attr('data-disable-with', this.updatedText)
  }

  window.ProcurementHub.FileInputModule = FileInputModule
}())

$(function () {
  $('input[type=file]').each(function (i, element) {
    // eslint-disable-next-line no-new
    new ProcurementHub.FileInputModule({
      el: element
    })
  })
})
