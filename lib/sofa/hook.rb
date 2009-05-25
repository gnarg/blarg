module Sofa
  module Hook
    def self.included(model)
      model.class_eval <<-EOS, __FILE__, __LINE__
      include Extlib::Hook
      register_instance_hooks :save
EOS
    end
  end
end