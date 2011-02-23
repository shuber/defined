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

  def test_should_call_defined_when_module_is_defined
    assert Mock.called
  end

  def test_method_should_be_class_or_module_when_defined_with_keywords
    assert_equal :module, Mock.method
    assert_equal :class, Dummy.method
  end

  def test_should_call_defined_when_module_is_defined_with_new
    mod = Module.new { extend TestMethods }
    assert mod.called
    assert_equal :initialize, mod.method
  end

  def test_should_call_defined_when_module_is_defined_with_class_eval
    Mock.class_eval { @called = false }
    assert Mock.called
    assert_equal :class_eval, Mock.method
  end

  def test_should_call_defined_when_module_is_defined_with_class_exec
    Mock.class_exec { @called = false }
    assert Mock.called
    assert_equal :class_exec, Mock.method
  end

  def test_should_call_defined_when_module_is_defined_with_instance_eval
    Mock.instance_eval { @called = false }
    assert Mock.called
    assert_equal :instance_eval, Mock.method
  end

  def test_should_call_defined_when_module_is_defined_with_instance_exec
    Mock.instance_exec { @called = false }
    assert Mock.called
    assert_equal :instance_exec, Mock.method
  end

  def test_should_call_defined_when_module_is_defined_with_module_eval
    Mock.module_eval { @called = false }
    assert Mock.called
    assert_equal :module_eval, Mock.method
  end

  def test_should_call_defined_when_module_is_defined_with_module_exec
    Mock.module_exec { @called = false }
    assert Mock.called
    assert_equal :module_exec, Mock.method
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

  def test_trace_function_should_add_definition
  end

  def test_trace_function_should_remove_definition
  end
end