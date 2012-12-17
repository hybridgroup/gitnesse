Given /^there is a code repo with cucumber features defined$/ do
  @repo_dir = File.join(Dir.home, ".gitnesse_repo")
end

Given /^there is a code repo without any cucumber features defined$/ do
  @repo_dir = File.join(Dir.home, ".gitnesse_repo_no_features")
end

Given /^there is a git wiki with cucumber features defined$/ do
  @features_dir = File.join(Dir.home, ".gitnesse_features")

  config_file = File.join(@repo_dir, "gitnesse.rb")
  config = File.read(config_file)
  config.gsub!(/config\.repository_url.*$/, "config.repository_url = '#{@features_dir}'")
  File.open(config_file, 'w') { |file| file.puts config }
end

Given /^there is a git wiki without any cucumber features defined$/ do
  @features_dir = File.join(Dir.home, ".gitnesse_features_no_features")

  config_file = File.join(@repo_dir, "gitnesse.rb")
  config = File.read(config_file)
  config.gsub!(/config\.repository_url.*$/, "config.repository_url = '#{@features_dir}'")
  File.open(config_file, 'w') { |file| file.puts config }
end

When /^developer pulls feature stories from the wiki$/ do
  Dir.chdir(@repo_dir) do
    `bundle exec rake gitnesse:pull &> /dev/null`
    assert_equal $?, 0
  end
end

When /^developer pushes feature stories to the wiki$/ do
  Dir.chdir(@repo_dir) do
    `bundle exec rake gitnesse:push &> /dev/null`
    assert_equal $?, 0
  end
end

Then /^the feature stories within the code should match the wiki$/ do
  assert_dir = File.join(Dir.home, ".gitnesse_features_for_assert")

  `git clone #{@features_dir} #{assert_dir} &> /dev/null`

  repo_features = Dir.glob("#{@repo_dir}/features/*.feature").map { |file| File.basename(file, ".feature") }
  wiki_files    = Dir.glob("#{assert_dir}/*.md").map { |file| File.basename(file, ".md") }

  FileUtils.rm_rf(assert_dir)

  repo_features.each do |feature|
    assert(wiki_files.include?(feature) || wiki_files.include?("#{feature}.feature"))
  end
end
