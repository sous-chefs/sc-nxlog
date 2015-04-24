def invoke_task(task_name)
  Rake::Task[task_name].invoke
  puts "Task #{task_name} finished successfully"
  false
rescue RuntimeError
  $stderr.puts "Task #{task_name} failed"
  true
end

def run_tests(tests)
  failed = false
  tests.each do |tn|
    failed ||= invoke_task(tn)
  end
  fail 'One or more tests failed' if failed
end

desc 'Runs a quick set of tests (the same as test:quick)'
task test: 'test:quick'

namespace :test do
  desc 'Run foodcritic, a cookbook linting tool'
  task :foodcritic do
    fail 'tests failed' unless system 'bundle exec foodcritic --epic-fail any .'
  end

  desc 'Run rubocop, a code standards enforcer'
  task :rubocop do
    fail 'tests failed' unless system 'bundle exec rubocop'
  end

  desc 'Run the cookbook unit tests'
  task :chefspec do
    fail 'tests failed' unless system 'bundle exec rspec --color'
  end

  desc 'Run test-kitchen to test the cookbook on multiple platforms'
  task :kitchen do
    fail 'tests failed' unless system 'bundle exec kitchen test all'
  end

  desc 'Run all tests except kitchen (which takes a long time)'
  task :quick do
    run_tests %w(test:foodcritic test:rubocop test:chefspec)
  end

  desc 'Run all tests, including kitchen'
  task :all do
    run_tests %w(test:foodcritic test:rubocop test:chefspec test:kitchen)
  end

  desc 'Run all tests with output tweaked for teamcity'
  task teamcity: 'test:teamcity:all'

  namespace :teamcity do
    desc 'Run rubocop, a code standards enforcer'
    task :rubocop do
      fail 'tests failed' unless system 'bundle exec rubocop ' \
        '--no-color --require rubocop/formatter/junit_formatter '\
        '--format RuboCop::Formatter::JUnitFormatter --out .junit/rubocop.xml'
    end

    desc 'Run test-kitchen to test the cookbook on multiple platforms'
    task :kitchen do
      fail 'tests failed' unless system 'TEAMCITY=1 bundle exec kitchen ' \
        'test all --destroy always | cat'
    end

    desc 'Run the cookbook unit tests'
    task :chefspec do
      fail 'tests failed' unless system 'bundle exec rspec ' \
       '-f RspecJunitFormatter -o .junit/rspec.xml'
    end

    desc 'Run all tests with output tweaked for teamcity'
    task :all do
      run_tests %w(test:foodcritic test:teamcity:rubocop
                   test:teamcity:chefspec test:teamcity:kitchen)
    end
  end
end
