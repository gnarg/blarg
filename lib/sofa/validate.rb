require 'rubygems'
require 'dm-validations'

module Sofa
  module Validate
    include DataMapper::Validate    

    def self.included(base)
      base.extend DataMapper::Validate::ClassMethods

      base.class_eval <<-EOS, __FILE__, __LINE__
      include Extlib::Hook
      register_instance_hooks :save
      register_class_hooks :create
EOS
    end

  end
end