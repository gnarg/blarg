require 'dm-validations'

module Sofa
  module Validate
    include DataMapper::Validate    

    def self.included(base)
      base.extend DataMapper::Validate::ClassMethods
    end

    def errors
      @errors ||= ValidationErrors.new
    end
  end
end