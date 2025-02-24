# frozen_string_literal: true

module ViewComponent
  # Keeps track of which templates have already been compiled
  # This isn't part of the public API
  module CompileCache
    mattr_accessor :cache, instance_reader: false, instance_accessor: false do
      Set.new
    end

    module_function

    def register(klass)
      cache << klass
    end

    def compiled?(klass)
      cache.include? klass
    end

    def invalidate_class!(klass)
      cache.delete(klass)
      klass.compiler.reset_render_template_for
    end

    def invalidate!
      cache.each { |klass| invalidate_class!(klass) }
    end
  end
end
