(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function CollapsibleSectionModule (options) {
    this.el = options.el
    this.$el = $(this.el)
    this.expandedClass = 'expanded-section'

    this.$header = this.$el.find('h2')
    this.$inner = this.$el.find('.inner')

    this.visible = false
    this.$inner.hide()

    this.$el.addClass('collapsible-section')

    this.bindEvents()
  }

  CollapsibleSectionModule.prototype.bindEvents = function bindEvents () {
    this.$header.on('click', $.proxy(this.toggleDisplay, this))
  }

  CollapsibleSectionModule.prototype.toggleDisplay = function toggleDisplay () {
    if (this.visible === true) {
      this.$inner.hide()
      this.visible = false
      this.$el.removeClass(this.expandedClass)
    } else {
      this.$inner.show()
      this.visible = true
      this.$el.addClass(this.expandedClass)
    }
  }

  window.ProcurementHub.CollapsibleSectionModule = CollapsibleSectionModule
}())

$(function () {
  $('*[data-module="collapsible-section"]').each(function (i, element) {
    new ProcurementHub.CollapsibleSectionModule({
      el: element
    })
  })
})
