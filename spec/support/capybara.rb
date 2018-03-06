require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

# Enable automatic_label_click to support our custom checkbox and radio button
# implementations. When this option is disabled, our JS tests fail as the driver
# 'sees' the controls as 'non-visible'.
#
Capybara.automatic_label_click = true
