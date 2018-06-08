(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function FurtherDetailsFieldsModule (options) {
    this.$el = options.$el
    this.$input = this.$el.find('*[data-further-details=input]')
    this.$fields = this.$el.find('> *[data-further-details=fields]')
    this.showValues = this.fetchValues()
    this.multipleOptions = (this.$el.attr('data-further-details-multiple-options') === 'true')

    this.registerEvents()
    this.refreshFields()
  }

  FurtherDetailsFieldsModule.prototype.registerEvents = function registerEvents () {
    this.$input.on('change', $.proxy(this.refreshFields, this))
  }

  FurtherDetailsFieldsModule.prototype.fetchValues = function fetchValues () {
    var string = this.$el.attr('data-further-details-values')

    if (string === undefined) {
      return []
    }

    return string.split(',')
  }

  FurtherDetailsFieldsModule.prototype.refreshFields = function refreshFields () {
    var values = []
    var $checkedEls = this.$input.filter(':checked')

    $checkedEls.each(function () {
      values.push($(this).val())
    })

    if (this.multipleOptions === true) {
      $.each(this.$fields, function (i, field) {
        var matchingValue = $(field).attr('data-further-details-value')

        if (values.indexOf(matchingValue) >= 0) {
          $(field).show()
        } else {
          $(field).hide()
        }
      })
    } else {
      var matching = this.showValues.filter(function (item) {
        return (values.indexOf(item) >= 0)
      })

      if (matching.length > 0) {
        this.$fields.show()
      } else {
        this.$fields.hide()
      }
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
