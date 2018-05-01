(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function MaxWordCount (options) {
    this.$el = options.$el
    this.$input = this.$el.find('textarea')
    this.$label = this.insertLabel()

    this.maxWordCount = this.$el.attr('data-max-word-count')

    this.registerEvents()
    this.hideErrorMessage()
    this.calculateWordCount()
  }

  MaxWordCount.prototype.registerEvents = function registerEvents () {
    this.$input.on('keyup', $.proxy(this.calculateWordCount, this))
  }

  MaxWordCount.prototype.hideErrorMessage = function hideErrorMessage () {
    /*
    Showing both the standard server-side rendered error message ('exceeds the
    word count') *and* our dynamic word count validator will confuse users – so
    we will hide the server-side generated error message when the JS is working.
    */
    this.$el.find('.invalid-feedback').hide()
  }

  MaxWordCount.prototype.insertLabel = function insertLabel () {
    var label = $('<span></span>')
    label.addClass('word-count-label')
    label.insertAfter(this.$input)

    return label
  }

  MaxWordCount.prototype.calculateWordCount = function calculateWordCount () {
    var value = this.$input.val()

    var wordCount = value.split(/[\s,]+/).filter(function (word) {
      return word.trim().length > 0
    }).length

    var remainingWords = this.maxWordCount - wordCount
    var excessWords = (0 - remainingWords)

    var text

    if (remainingWords > 1 || remainingWords === 0) {
      text = remainingWords + ' words remaining'
    } else if (remainingWords === 1) {
      text = remainingWords + ' word remaining'
    } else if (excessWords === 1) {
      text = excessWords + ' word too many'
    } else {
      text = excessWords + ' words too many'
    }

    if (excessWords > 0) {
      this.$label.addClass('invalid')
    } else {
      this.$label.removeClass('invalid')
    }

    this.$label.text(text)
  }

  window.ProcurementHub.MaxWordCount = MaxWordCount
}())

$(function () {
  $('*[data-module="max-word-count"]').each(
    function (i, el) {
      new window.ProcurementHub.MaxWordCount({
        $el: $(el)
      })
    }
  )
})
