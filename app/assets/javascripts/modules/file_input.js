(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function FileInputModule (options) {
    this.el = options.el
    this.$el = $(this.el)
    this.$label = this.$el.siblings('label').first()

    this.bindEvents()
  }

  FileInputModule.prototype.bindEvents = function bindEvents () {
    this.$el.on('change', $.proxy(this.updateLabelText, this))
  }

  FileInputModule.prototype.updateLabelText = function updateLabelText () {
    var file = this.el.files[0]
    var size = Math.round(file.size / 1000)

    this.$label.text(file.name + ' (' + size + ' kB)')
    this.$el.addClass('with-attached-file')
  }

  window.ProcurementHub.FileInputModule = FileInputModule
}())

$(function () {
  $('input.custom-file-input').each(function (i, element) {
    new ProcurementHub.FileInputModule({
      el: element
    })
  })
})
