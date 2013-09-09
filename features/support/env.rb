require 'gitnesse'

require 'rspec'
require 'cucumber/rspec/doubles'

wiki_url = "https://github.com/hybridgroup/gitnesse-demo.wiki.git"
repo_url = "https://github.com/hybridgroup/gitnesse-example-sinatra.git"

RSpec::Mocks::setup(self)

puts "Setting up Gitnesse for Cucumber testing:"

@root = File.join(Dir.home, ".gitnesse/_features")
FileUtils.mkdir_p(@root) unless File.directory?(@root)

@wiki_with_features = File.join(@root, "/wiki_with_features")
@wiki_without_features = File.join(@root, "/wiki_without_features")
@repo_with_features = File.join(@root, "/repo_with_features")
@repo_without_features = File.join(@root, "/repo_without_features")

dirs = [@wiki_with_features, @wiki_without_features, @repo_with_features,
        @repo_without_features]

dirs.each do |dir|
  FileUtils.rm_rf dir
  FileUtils.mkdir_p dir
end

Dir.chdir(@wiki_with_features) do
  puts "Cloning demo features wiki."
  system("git clone --bare #{wiki_url} . &> /dev/null")
  abort "Failed to clone demo features to #{@wiki_with_features}." if $? != 0
end

Dir.chdir(@wiki_without_features) do
  puts "Creating demo wiki without features"
  system("git init --bare &> /dev/null")
  abort "Failed to create demo wiki in #{@wiki_without_features}." if $? != 0
end

Dir.chdir(@repo_with_features) do
  puts "Cloning repo with existing features"
  system "git clone #{repo_url} . &> /dev/null"
  abort "Failed to clone demo repo to #{@repo_with_features}." if $? != 0

  puts "Installing gems for demo repo."
  Bundler.with_clean_env do
    system "bundle install --path vendor/bundle &> /dev/null"
  end
  abort "Failed to install gems for demo repo #{@repo_with_features}" if $? != 0
end

Dir.chdir(@repo_without_features) do
  puts "Creating demo repo without features."
  FileUtils.cp_r("#{@repo_with_features}/.", @repo_without_features)
  Dir.glob("#{@repo_without_features}/**/*.feature") { |f| File.unlink(f) }
end

puts "Finished setting up Gitnesse for testing. Running features.", ''

at_exit do
  dirs.each do |dir|
    FileUtils.rm_rf dir
  end
end
