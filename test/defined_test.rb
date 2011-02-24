require 'test_helper'

class DefinedTest < Test::Unit::TestCase
  module TestMethods
    attr_reader :file, :line, :method, :called

    def defined(file, line, method)
      @file, @line, @method, @called = file, line, method, true
    end
  end

  module Mock
    extend TestMethods
  end

  class Dummy
    extend TestMethods
  end

  def test_should_match_definition_start?
  end

  def test_should_not_match_definition_start?
  end

  def test_should_match_definition_end?
  end

  def test_should_not_match_definition_end?
  end

  def test_should_not_match_end_without_start
  end

  def test_method_should_be_class_or_module_when_defined_with_keywords
    assert_equal :module, Mock.method
    assert_equal :class, Dummy.method
  end

  def test_should_not_call_defined_unless_implemented
    mod = Module.new
    assert !mod.respond_to?(:defined)
  end

  def test_should_call_defined_when_module_is_defined
    assert Mock.called
  end

  def test_should_call_defined_when_module_is_defined_with_new
    mod = Module.new { extend TestMethods }
    assert mod.called
    assert_equal :initialize, mod.method
  end

  %w(class instance module).each do |prefix|
    %w(eval exec).each do |suffix|
      method_name = [prefix, suffix].join('_').to_sym
      define_method "test_should_call_defined_when_module_is_defined_with_#{method_name}" do
        Mock.send(method_name) { @called = false }
        assert Mock.called
        assert_equal method_name, Mock.method
      end
    end
  end
end