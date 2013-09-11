When(/^I pull features$/) do
  Dir.chdir(@repo_dir) do
    system "gitnesse pull &> /dev/null"
  end
end
