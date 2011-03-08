require File.expand_path('../test_helper', __FILE__)

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

  def test_should_match_definition_start_with_keyword
    assert Defined.send(:definition_start?, 'class', false, false)
  end

  def test_should_not_match_definition_start_with_wrong_keyword
    assert !Defined.send(:definition_start?, 'wrong_keyword', :class_eval, false)
  end

  def test_should_match_definition_start_with_method
    assert Defined.send(:definition_start?, 'c-call', :class_eval, false)
  end

  def test_should_not_match_definition_start_with_normal_method
    assert !Defined.send(:definition_start?, 'c-call', :normal_method, false)
  end

  def test_should_match_definition_start_with_initialize
    assert Defined.send(:definition_start?, 'c-call', :initialize, Module.new)
  end

  def test_should_not_match_definition_start_with_initialize_if_not_called_on_module_or_class
    assert Defined.send(:definition_start?, 'c-call', :initialize, Dummy)
  end

  def test_should_match_definition_end_with_keyword
    with_dummy_definition do
      assert Defined.send(:definition_end?, 'end', false, false)
    end
  end

  def test_should_not_match_definition_end_with_wrong_keyword
    with_dummy_definition do
      assert !Defined.send(:definition_end?, 'wrong_keyword', :class_eval, false)
    end
  end

  def test_should_match_definition_end_with_method
    with_dummy_definition do
      assert Defined.send(:definition_end?, 'c-return', :class_eval, false)
    end
  end

  def test_should_not_match_definition_end_with_normal_method
    with_dummy_definition do
      assert !Defined.send(:definition_end?, 'c-return', :normal_method, false)
    end
  end

  def test_should_match_definition_end_with_initialize
    with_dummy_definition do
      assert Defined.send(:definition_end?, 'c-return', :initialize, Module.new)
    end
  end

  def test_should_not_match_definition_end_with_initialize_if_not_called_on_module_or_class
    with_dummy_definition do
      assert Defined.send(:definition_end?, 'c-return', :initialize, Dummy)
    end
  end

  def test_should_not_match_end_without_start
    assert !Defined.send(:definition_end?, 'end', false, false)
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
    assert mod.called, 'Mock.defined was not called after calling Module.new'
    assert_equal :initialize, mod.method
  end

  %w(class instance module).each do |prefix|
    %w(eval exec).each do |suffix|
      method_name = [prefix, suffix].join('_').to_sym
      if respond_to?(method_name)
        define_method "test_should_call_defined_when_module_is_defined_with_#{method_name}" do
          Mock.send(method_name) { @called = false }
          assert Mock.called, "Mock.defined was not called after calling #{method_name}"
          assert_equal method_name, Mock.method
        end
      end
    end
  end

  protected

    def with_dummy_definition
      Defined.definitions << Dummy
      yield
      Defined.definitions.pop
    end
end