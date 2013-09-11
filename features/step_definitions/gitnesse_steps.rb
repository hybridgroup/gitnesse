Given(/^there is a wiki with Cucumber features defined$/) do
  @wiki_dir = File.join(Dir.home, ".gitnesse/_features/wiki_with_features")
end

Given(/^there is a wiki with no Cucumber features defined$/) do
  @wiki_dir = File.join(Dir.home, ".gitnesse/_features/wiki_without_features")
end

Given(/^there are no local features$/) do
  @repo_dir = File.join(Dir.home, ".gitnesse/_features/repo_without_features")
end

Given(/^there are local features$/) do
  @repo_dir = File.join(Dir.home, ".gitnesse/_features/repo_with_features")
end

Then(/^the local features should match the wiki$/) do
  @assertion_dir = File.join(Dir.home, ".gitnesse/_features/assert")

  system "git clone #{@wiki_dir} #{@assertion_dir} &> /dev/null"

  wiki_features = Dir.glob("#{@assertion_dir}/**/*.feature.md")
  repo_features = Dir.glob("#{@repo_dir}/features/**/*.feature")

  wiki_features.map! { |f| File.basename(f, ".md") }
  repo_features.map! { |f| File.basename(f)  }

  FileUtils.rm_rf(@assertion_dir)
  FileUtils.mkdir_p(@assertion_dir)

  wiki_features.each do |feature|
    expect(repo_features).to include feature
  end
end
