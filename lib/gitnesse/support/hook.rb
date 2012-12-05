require 'gitnesse'

Gitnesse::Hooks.setup

After do |scenario|
  Gitnesse::Hooks.append_to_wiki(scenario)
end

at_exit do
  Gitnesse::Hooks.teardown
end
