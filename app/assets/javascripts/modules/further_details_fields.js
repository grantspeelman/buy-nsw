(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function FurtherDetailsFieldsModule (options) {
    this.$el = options.$el
    this.$input = this.$el.find('*[data-further-details=input]')
    this.$fields = this.$el.find('*[data-further-details=fields]')
    this.showValues = this.$el.attr('data-further-details-values').split(',')

    this.registerEvents()
    this.refreshFields()
  }

  FurtherDetailsFieldsModule.prototype.registerEvents = function registerEvents () {
    this.$input.on('change', $.proxy(this.refreshFields, this))
  }

  FurtherDetailsFieldsModule.prototype.refreshFields = function refreshFields () {
    var values = []
    var $checkedEls = this.$input.filter(':checked')

    $checkedEls.each(function () {
      values.push($(this).val())
    })

    var matching = this.showValues.filter(function (item) {
      return (values.includes(item))
    })

    if (matching.length > 0) {
      this.$fields.show()
    } else {
      this.$fields.hide()
    }
  }

  window.ProcurementHub.FurtherDetailsFieldsModule = FurtherDetailsFieldsModule
}())

$(function () {
  $('*[data-module="further-details-fields"]').each(
    function (i, element) {
      // eslint-disable-next-line no-new
      new window.ProcurementHub.FurtherDetailsFieldsModule({
        $el: $(element)
      })
    }
  )
})
