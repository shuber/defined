# Calls <tt>Module#defined(file, line, method)</tt> whenever a class or module is defined or redefined
module Defined
  autoload :Version, 'defined/version'

  class << self
    def included(mod) # :nodoc:
      set_trace_func method(:trace_function).to_proc
    end

    protected

      # An array of classes and modules that are currently being defined
      def definitions
        @definitions ||= []
      end

      def definition?(event, method, klass, keyword_event, method_event)
        event == keyword_event || (event == method_event && definition_method?(method, klass))
      end

      # Checks if the event is the end of a class or module definition
      def definition_end?(event, method, klass)
        !definitions.empty? && definition?(event, method, klass, 'end', 'c-return')
      end

      # Checks if the event is a call to <tt>Module.new</tt>, <tt>Class.new</tt>, or <tt>/(class|instance|module)_(eval|exec)/</tt>
      def definition_method?(method, klass)
        (method == :initialize && klass.is_a?(Module)) || method.to_s =~ /^(class|instance|module)_(eval|exec)$/
      end

      # Checks if the event is the start of a class or module definition
      def definition_start?(event, method, klass)
        definition?(event, method, klass, 'class', 'c-call')
      end

      # Checks if the event is the end of a class or module definition, and if so
      # it calls <tt>Module#defined(file, line, method)</tt> if implemented
      def trace_function(event, file, line, method, binding, klass)
        if definition_start?(event, method, klass)
          definitions << binding.eval('self')
        elsif definition_end?(event, method, klass)
          object = definitions.pop
          method ||= object.class.name.downcase.to_sym
          object.defined(file, line, method) if object.respond_to?(:defined)
        end
      end
  end
end

Module.send(:include, Defined)