desc 'Runs a quick set of tests (the same as test:quick)'
task test: 'test:quick'

namespace :test do
  desc 'Run all tests except kitchen (which takes a long time)'
  task :quick do
    system 'bundle exec strainer test -e kitchen'
  end

  desc 'Run all tests, including kitchen'
  task :all do
    system "bundle exec strainer test"
  end
end

