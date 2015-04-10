require 'minitest'
require 'minitest/autorun'

require_relative '../lib/minitest/hog'

class HogReporterTest < Minitest::Test
  MAX_MEMORY = 8
  attr_reader :reporter
  attr_reader :result
  attr_reader :io
  
  class SampleTest < Minitest::Test
    include Minitest::Hog
  end
  
  def setup
    @io       = StringIO.new
    @reporter = Minitest::HogReporter.new(@io)
    @result   = SampleTest.new "sample"
  end
  
  def test_piggy_test_cases_are_recorded
    result.memory_used = reporter.max_memory + 1
    
    reporter.record result
    results = reporter.piggy_tests
    
    assert_equal 1, results.length
  end
  
  def test_low_memory_test_cases_are_not_recorded
    result.memory_used = 0
    
    reporter.record result
    
    assert reporter.piggy_tests.empty?
  end
  
  def test_reports_on_piggy_tests
    result.memory_used = 768
    reporter.piggy_tests << result
    
    reporter.report
    
    assert_includes io.string, result.location
    assert_includes io.string, "768 kb"
  end
  
  def test_max_memory_is_configurable
    expected_max = 1337
    @reporter = Minitest::HogReporter.new(@io, max_memory: 1337)
    
    assert_equal expected_max, @reporter.max_memory
  end
  
end

