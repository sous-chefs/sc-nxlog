def invoke_task(task_name)
  Rake::Task[task_name].invoke
  puts "Task #{task_name} finished successfully"
  false
rescue RuntimeError
  warn "Task #{task_name} failed"
  true
end

def run_tests(tests)
  failed = false
  tests.each do |tn|
    failed = invoke_task(tn) || failed
  end
  raise 'One or more tests failed' if failed
end

desc 'Runs a quick set of tests (the same as test:quick)'
task test: 'test:quick'

namespace :test do
  desc 'Run foodcritic, a cookbook linting tool'
  task :foodcritic do
    raise 'tests failed' unless system 'foodcritic --epic-fail any .'
  end

  desc 'Run cookstyle, a code standards enforcer'
  task :cookstyle do
    raise 'tests failed' unless system 'cookstyle'
  end

  desc 'Run the cookbook unit tests'
  task :chefspec do
    raise 'tests failed' unless system 'rspec --color'
  end

  desc 'Run test-kitchen to test the cookbook on multiple platforms'
  task :kitchen do
    raise 'tests failed' unless system 'bundle exec kitchen test all'
  end

  desc 'Run all tests except kitchen (which takes a long time)'
  task :quick do
    run_tests %w(test:foodcritic test:cookstyle test:chefspec)
  end

  desc 'Run all tests, including kitchen'
  task :all do
    run_tests %w(test:foodcritic test:cookstyle test:chefspec test:kitchen)
  end
end
