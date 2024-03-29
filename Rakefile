require 'rspec/core/rake_task'
require 'bundler'

task :build => :test do
  system "gem build easy_translate.gemspec"
end

task :release => :build do
  # tag and push
  version = Bundler.load_gemspec('easy_translate.gemspec').version
  system "git tag v#{version}"
  system "git push origin --tags"
  # push the gem
  system "gem push easy_translate-#{version}.gem"
end

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  fail_on_error = true # be explicit
end

task :default => :test

desc "Cache API languages into lib/easy_translate/languages.rb, must set GOOGLE_TRANSLATE_API_KEY"
task :cache_languages do
  $: << "lib"
  require "easy_translate"
  EasyTranslate.api_key = ENV.fetch("GOOGLE_TRANSLATE_API_KEY")

  language_filename = "lib/easy_translate/languages.rb"
  previous_contents = File.read(language_filename)

  response = JSON.parse(EasyTranslate::TranslationTarget::TranslationTargetRequest.new("en").perform_raw)
  language_keys = response.dig("data", "languages").map do |info|
    [info["name"].downcase.gsub(/[^a-z ]/, "").tr(" ", "_"), info["language"]]
  end.sort.map do |n, l|
    "    '#{l}' => '#{n}'"
  end.join(",\n")
  new_contents = previous_contents.sub(/(LANGUAGES = {).*?(})/m, "\\1\n#{language_keys}\n  \\2")

  File.open(language_filename, "w") do |f|
    f.write(new_contents)
  end
end
