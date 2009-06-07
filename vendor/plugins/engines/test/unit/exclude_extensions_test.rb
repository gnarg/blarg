require File.dirname(__FILE__) + '/../test_helper'

class ArbitraryCodeMixingTest < Test::Unit::TestCase
  def setup
    Engines.exclude_extensions = [:migrations]
  end

  def test_migrations_should_not_be_loaded
    assert false
  end
end
