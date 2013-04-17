libs = %w(config converts_feature_to_markdown git_config_reader
          feature_extractor version checks_dependencies)

libs.each do |lib|
  require "gitnesse/#{lib}"
end

module Gitnesse
end
