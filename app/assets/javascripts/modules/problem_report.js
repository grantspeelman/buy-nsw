(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function ProblemReportModule (options) {
    this.$el = options.$el
    this.$form = this.$el.find('form')
    this.$response = this.$el.find('.problem-report-response')

    this.label = this.$el.attr('data-problem-report-label')
    this.errorMessage = this.$el.attr('data-problem-report-error')
    this.invalidMessage = this.$el.attr('data-problem-report-invalid')

    this.$link = this.addLink()
    this.$form.hide().attr('aria-hidden', 'true')
    this.bindFormEvents()
  }

  ProblemReportModule.prototype.addLink = function () {
    var $linkContainer = this.$el.find('.problem-report-link')
    var $link = $('<a></a>')

    $link.text(this.label).attr('href', '#')

    $link.on('click', $.proxy(this.openForm, this))
    $link.appendTo($linkContainer)

    return $link
  }

  ProblemReportModule.prototype.removeLink = function () {
    this.$link.remove()
  }

  ProblemReportModule.prototype.openForm = function (event) {
    event.preventDefault()

    this.$form.show().removeAttr('aria-hidden')
    this.$form.find('input[type=text]').first().focus()
    this.removeLink()
  }

  ProblemReportModule.prototype.bindFormEvents = function () {
    this.$form.on('submit', $.proxy(this.submitForm, this))
  }

  ProblemReportModule.prototype.submitForm = function (event) {
    event.preventDefault()

    var $task = this.$form.find('input[name="task"]')
    var $issue = this.$form.find('input[name="issue"]')

    this.$form.find('.error').remove()
    this.$form.find('input').removeClass('is-invalid')

    var data = {
      task: $task.val(),
      issue: $issue.val(),
      url: window.location.href,
      referer: document.referrer,
      browser: navigator.userAgent
    }

    $.ajax({
      url: this.$form.attr('action'),
      dataType: 'json',
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(data),
      success: $.proxy(this.handleSuccessResponse, this),
      error: $.proxy(this.handleErrorResponse, this)
    })
  }

  ProblemReportModule.prototype.handleSuccessResponse = function (response) {
    this.$form.remove()
    this.$response.text(response.message)
    this.$reponse.focus()
  }

  ProblemReportModule.prototype.handleErrorResponse = function (response) {
    this.$form.find('input[type=submit]').removeAttr('disabled')
    var $error = $('<div></div>')
    $error.addClass('error')

    if (response.status === 422) {
      var $emptyInputs = this.$form.find('input').filter(function () {
        return this.value === ''
      })

      $emptyInputs.addClass('is-invalid')

      $error.addClass('mini-error')
      $error.html(this.invalidMessage)
      $error.insertAfter(this.$form.find('h1'))
    } else {
      $error.text(this.errorMessage)

      $error.addClass('block-error')
      $error.prependTo(this.$form)
    }
    $error.focus()
  }

  window.ProcurementHub.ProblemReportModule = ProblemReportModule
}())

$(function () {
  $('*[data-module="problem-report"]').each(
    function (i, element) {
      // eslint-disable-next-line no-new
      new window.ProcurementHub.ProblemReportModule({
        $el: $(element)
      })
    }
  )
})
