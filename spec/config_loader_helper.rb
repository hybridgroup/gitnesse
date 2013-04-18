def example_config_file
  <<-EOS
Gitnesse::Config.config do |config|
  config.annotate_results = true
  config.commit_info = "Uncle Bob's Laptop"
end
  EOS
end
