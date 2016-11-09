require 'capybara'
require 'capybara/dsl'

require 'capybara/poltergeist'

include Capybara::DSL
Capybara.default_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {js_errors: false})
end

Capybara.default_driver = :poltergeist

visit "https://app.bugsnag.com/user/sign_in"

fill_in 'Email', with: ENV['BUGSNAG_EMAIL']
fill_in 'Password', with: ENV['BUGSNAG_PASSWORD']

click_on 'Sign in'

sleep 2 # required

first('span', text: '7d').trigger('click')

sleep 5 # required

seven_day_error_occurrences = all(".DataTable-row .DataTable-cell:nth-child(3)").reduce(0) do |accum, node|
  accum + node.text.to_i
end

puts "Total of occurrences for 7 days: #{seven_day_error_occurrences}"

