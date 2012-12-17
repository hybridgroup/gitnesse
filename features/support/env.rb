require 'test/unit/assertions'
World(Test::Unit::Assertions)

puts "  Setting up Gitnesse for testing..."

@features_dir = File.join(Dir.home, ".gitnesse_features")
@features_dir_no_features = File.join(Dir.home, ".gitnesse_features_no_features")
@repo_dir = File.join(Dir.home, ".gitnesse_repo")
@repo_dir_no_features = File.join(Dir.home, ".gitnesse_repo_no_features")

Dir.mkdir @features_dir
Dir.mkdir @repo_dir
Dir.mkdir @features_dir_no_features
Dir.mkdir @repo_dir_no_features

Dir.chdir(@features_dir) do
  system('git clone --bare https://github.com/hybridgroup/gitnesse-demo.wiki.git . &> /dev/null')
  if $? == 0
    puts "  Cloned demo features to #{@features_dir}."
  else
    abort "  Failed to clone demo features to #{@features_dir}."
  end
end

Dir.chdir(@features_dir_no_features) do
  system('git init --bare &> /dev/null')
  if $? == 0
    puts "  Created demo wiki without features in #{@features_dir_no_features}."
  else
    abort "  Failed to create demo wiki without features in #{@features_dir_no_features}."
  end
end

Dir.chdir(@repo_dir) do
  system('git clone https://github.com/hybridgroup/gitnesse-example-sinatra.git . &> /dev/null')
  if $? == 0
    puts "  Cloned demo repo to #{@repo_dir}."
  else
    abort "  Failed to clone demo repo to #{@repo_dir}."
  end

  system('bundle install --path vendor/bundle &> /dev/null')
  if $? == 0
    puts "  Installed gems for demo wiki."
  else
    abort "  Failed to install gems for demo wiki."
  end
end

config_file = File.join(@repo_dir, "gitnesse.rb")

config = File.read(config_file)
config.gsub!(/config\.repository_url.*$/, "config.repository_url = '#{@features_dir}'")
File.open(config_file, 'w') { |file| file.puts config }

puts "  Updated demo repo configuration to use demo features."

Dir.chdir(@repo_dir_no_features) do
  FileUtils.cp_r("#{@repo_dir}/.", @repo_dir_no_features)
  Dir.glob("#{@repo_dir_no_features}/**/*.feature") do |file|
    File.unlink(file)
  end
  puts "  Created demo repo without features."
end

puts "  Finished setting up Gitnesse for testing. Running features.", ""

at_exit do
  FileUtils.rm_rf(@features_dir)
  FileUtils.rm_rf(@repo_dir)
  FileUtils.rm_rf(@features_dir_no_features)
  FileUtils.rm_rf(@repo_dir_no_features)
end
