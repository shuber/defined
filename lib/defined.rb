# Adds a <tt>Module.defined</tt> callback that is called whenever a class or module is defined or redefined
module Defined
  autoload :Version, 'defined/version'

  # The default <tt>defined</tt> callback implementation which does nothing
  def defined(file, line, method)
  end

  instance_eval do
    def definitions
      @definitions ||= []
    end

    def definition?(event, method, klass, keyword_event, method_event)
      event == keyword_event || (event == method_event && ((method == :new && klass.is_a?(Module)) || method.to_s =~ /^(class|instance|module)_eval$/))
    end

    def definition_start?(event, method, klass)
      definition?(event, method, klass, 'class', 'c-call')
    end

    def definition_end?(event, method, klass)
      !definitions.empty? && definition?(event, method, klass, 'end', 'c-return')
    end

    def included(mod)
      set_trace_func method(:trace_function).to_proc
    end

    def trace_function(event, file, line, method, binding, klass)
      if definition_start?(event, method, klass)
        definitions << binding.eval('self')
      elsif definition_end?(event, method, klass)
        object = definitions.pop
        method ||= object.class.to_s.downcase.to_sym
        object.defined(file, line, method) if object.respond_to?(:defined)
      end
    end
  end
end

Module.send(:include, Defined)