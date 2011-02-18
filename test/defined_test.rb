require 'test_helper'

class DefinedTest < Test::Unit::TestCase
  module TestMethods
    def called
      @called
    end

    def defined(file, line, method)
      @called = true
    end
  end

  module Mock
    extend TestMethods
  end

  def test_should_call_defined_when_module_is_defined
    assert Mock.called
  end

  def test_should_call_defined_when_module_is_defined_with_new
    mod = Module.new { extend TestMethods }
    assert mod.called
  end

  def test_should_call_defined_when_module_is_defined_with_class_eval
    Mock.class_eval { @called = false }
    assert Mock.called
  end

  def test_should_call_defined_when_module_is_defined_with_instance_eval
    Mock.instance_eval { @called = false }
    assert Mock.called
  end

  def test_should_call_defined_when_module_is_defined_with_module_eval
    Mock.module_eval { @called = false }
    assert Mock.called
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

  def test_method_should_be_class_or_module_when_defined_with_keywords
  end
end