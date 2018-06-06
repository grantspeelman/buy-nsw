(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function PasswordStrength (options) {
    this.$el = options.$el
    this.$input = this.$el.find('input[type=password]')
    this.$strengthOMeter = this.insertStrengthOMeter()
    this.scoring = [
      'Very weak',
      'Weak',
      'Average',
      'Strong',
      'Very strong'
    ]

    this.registerEvents()
    this.calculateStrength()
  }

  PasswordStrength.prototype.registerEvents = function registerEvents () {
    this.$input.on('keyup', $.proxy(this.calculateStrength, this))
  }

  PasswordStrength.prototype.insertStrengthOMeter = function insertStrengthOMeter () {
    var $container = $('<div></div>')
    var $label = $('<span></span>')

    $label.appendTo($container)
    $container.addClass('strength-o-meter')
    $container.insertAfter(this.$input)

    return $container
  }

  PasswordStrength.prototype.calculateStrength = function calculateStrength () {
    var password = this.$input.val()
    var $label = this.$strengthOMeter.find('span')

    if (password !== '') {
      var result = zxcvbn(password)
      var score = result.score
      var label = this.scoring[score]

      if (password.length < 8) {
        $label.text('Password is too short')
      } else if (score < 3) {
        $label.text('Password is not strong enough')
        this.$strengthOMeter.attr('class', 'strength-o-meter score-' + score)
      } else {
        $label.text('Password strength: ' + label)
        this.$strengthOMeter.attr('class', 'strength-o-meter score-' + score)
      }
    } else {
      $label.text('')
      this.$strengthOMeter.attr('class', 'strength-o-meter')
    }
  }

  window.ProcurementHub.PasswordStrength = PasswordStrength
}())

$(function () {
  $('*[data-module="password-strength"]').each(
    function (i, el) {
      // eslint-disable-next-line no-new
      new window.ProcurementHub.PasswordStrength({
        $el: $(el)
      })
    }
  )
})
