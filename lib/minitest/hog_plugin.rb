module Minitest
  @minitest_hog = false
  
  def self.plugin_hog_options(opts, options)
    opts.on "--max-memory MEM", Integer, "Report tests that use more than MEM kb." do |max_memory|
      options[:max_memory] = max_memory.to_i
    end
  end

  def self.plugin_hog_init(options)
    if options[:max_memory]
      require "minitest/hog"
      
      self.reporter << Minitest::HogReporter.new(options[:io], options)
      Minitest::Test.send :include, Minitest::Hog
    end
  end
end