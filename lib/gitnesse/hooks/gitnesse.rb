require 'gitnesse'

After do |scenario|
  Gitnesse::Hooks.append_results(scenario)
end
