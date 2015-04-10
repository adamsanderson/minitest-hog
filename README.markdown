Minitest Hog
======================

Prints a list of tests that take too long.

Installation
------------

    gem install minitest-hog
    
Usage
-----

Minitest Hog can be enabled from the command line using the `max-memory` parameter:

    ruby test/example_test.rb --max-memory 16
    
This would print out a list of any tests that use more than 16k of memory:

    # Running:

    ....

    Finished in 1.001143s

    4 runs, 7 assertions, 0 failures, 0 errors, 0 skips

    2 slow tests.
      0) ExampleTest#test_alpha: 31 kb
      1) ExampleTest#test_beta: 18 kb

Usage with Rake
---------------

If you run your tests with Rake, set the TESTOPTS environment variable:

    rake TESTOPTS="--max-memory 16"

Warning!
--------

There are many ways to measure memory usage in Ruby.  The results from Minitest Hog may not be exact, but should help you track down the most egregious memory hogs.

Authors 
-------

[Adam Sanderson](netghost@gmail.com) (http://monkeyandcrow.com)