require 'spec/rake/spectask'
require 'lib/easy_translate/version'
 
task :build => :test do
  system "gem build easy_translate.gemspec"
end

task :release => :build do
  # tag and push
  system "git tag v#{EasyTranslate::VERSION}"
  system "git push origin --tags"
  # push the gem
  system "gem push easy_translate-#{EasyTranslate::VERSION}.gem"
end
 
Spec::Rake::SpecTask.new(:test) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  fail_on_error = true # be explicit
end
 
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  fail_on_error = true # be explicit
end