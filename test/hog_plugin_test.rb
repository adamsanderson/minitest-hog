require 'minitest'
require 'minitest/mock'
require 'minitest/autorun'

require_relative '../lib/minitest/hog_plugin'

class SnailPluginTest < Minitest::Test
    
  def test_plugin_adds_hog_reporter_when_enabled
    initial_reporter = Minitest.reporter
    Minitest.reporter = Minitest::CompositeReporter.new
    
    options = {}
    Minitest.plugin_hog_init({:max_memory => 1})
    
    reporter_classes = Minitest.reporter.reporters.map(&:class)
    
    assert_equal [Minitest::HogReporter], reporter_classes
  ensure
    Minitest.reporter = initial_reporter
  end
  
end

