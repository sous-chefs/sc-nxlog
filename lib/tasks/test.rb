desc 'Runs a quick set of tests (the same as test:quick)'
task test: 'test:quick'

namespace :test do
  desc 'Run all tests except kitchen (which takes a long time)'
  task :quick do
    system 'bundle exec strainer test -e kitchen'
  end

  desc 'Run all tests, including kitchen'
  task :all do
    system 'bundle exec strainer test'
  end

  desc 'Runs a quick set of tests, with debugging enabled (test:debug:quick)'
  task debug: 'test:debug:quick'

  namespace :debug do
    desc 'Run all tests except kitchen, with debugging enabled'
    task :quick do
      system 'bundle exec strainer test -e kitchen --log-level=debug'
    end

    desc 'Run all tests, including kitchen, with debugging enabled'
    task :all do
      system 'bundle exec strainer test --log-level=debug'
    end
  end
end
