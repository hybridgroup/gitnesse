When(/^I push features$/) do
  Dir.chdir(@repo_dir) do
    system "gitnesse push &> /dev/null"
  end
end
