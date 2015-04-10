module Minitest
  module Hog

    attr_accessor :memory_used
  
    def self.sample
      sampler.call
    end
  
    def self.sampler= sampler
      @memory_sampler = sampler
    end
  
    def self.sampler
      @memory_sampler ||= Minitest::ShellPs.new
    end
  
    def before_setup
      super
      GC.start
      GC.disable
    
      self.memory_used = Minitest::Hog.sample
    end

    def after_teardown
      super
      if memory_used
        self.memory_used = Minitest::Hog.sample - memory_used
      else
        self.memory_used
      end
      
      GC.enable
    end
  
  end

  class HogReporter < Reporter
    Record = Struct.new :location, :memory_used
    attr_reader :piggy_tests, :max_memory
    
    def initialize(io = STDOUT, options = {})
      super
      
      @max_memory = options.fetch(:max_memory, 64)
      @piggy_tests = []
    end
    
    def record result
      if result.memory_used > max_memory
        piggy_tests << Record.new(result.location, result.memory_used)
      end
    end
    
    def report
      return if piggy_tests.empty?
      
      piggy_tests.sort_by!{|r| -r.memory_used}
      
      io.puts
      io.puts "#{piggy_tests.length} hogs."
      piggy_tests.each_with_index do |record, i|
        io.puts "%3d) %s: %i kb" % [i+1, record.location, record.memory_used]
      end
    end 
  end
  
  # Return the resident set size (RSS) in kB.
  # 
  # This is fairly foolproof, but probably not the most accurate measure possible
  # since shelling out most likely affects memory usage and isn't terribly efficient.
  #
  # Other strategies could be implemented in the future, for instance see NewRelic's samplers:
  # https://github.com/newrelic/rpm/blob/release/lib/new_relic/agent/samplers/memory_sampler.rb
  #
  class ShellPs
    def initialize(pid = Process::pid)
      @pid = pid
    end
    
    # Based off of: http://zogovic.com/post/59091704817/memory-usage-monitor-in-ruby
    # Example ps output: "  RSS\n223124\n"
    def call
      `ps -o rss -p #{@pid}`.split("\n").last.to_i
    end
  end
  
end