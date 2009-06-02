require 'rubygems'
require 'dm-validations'

module Sofa
  module Validate    
    def self.included(base)
      base.extend DataMapper::Validate::ClassMethods
    end

     def validations       
       throw :halt, false unless check_validations       
     end

      # Ensures the object is valid for the context provided, and otherwise
    # throws :halt and returns false.
    #
    def check_validations(context = :default)
      throw(:halt, false) unless context.nil? || valid?(context)

      true
    end

    # Return the ValidationErrors
    #
    def errors
      @errors ||= DataMapper::Validate::ValidationErrors.new
    end

    # Mark this resource as validatable. When we validate associations of a
    # resource we can check if they respond to validatable? before trying to
    # recursivly validate them
    #
    def validatable?
      true
    end

    # Alias for valid?(:default)
    #
    def valid_for_default?
      valid?(:default)
    end

    # Check if a resource is valid in a given context
    #
    def valid?(context = :default)
      self.class.validators.execute(context, self)
    end

    # Begin a recursive walk of the model checking validity
    #
    def all_valid?(context = :default)
      recursive_valid?(self, context, true)
    end

    # Do recursive validity checking
    #
    def recursive_valid?(target, context, state)
      valid = state
      target.instance_variables.each do |ivar|
        ivar_value = target.instance_variable_get(ivar)
        if ivar_value.validatable?
          valid = valid && recursive_valid?(ivar_value, context, valid)
        elsif ivar_value.respond_to?(:each)
          ivar_value.each do |item|
            if item.validatable?
              valid = valid && recursive_valid?(item, context, valid)
            end
          end
        end
      end
      return valid && target.valid?
    end


    def validation_property_value(name)
      self.respond_to?(name, true) ? self.send(name) : nil
    end

    # Get the corresponding Resource property, if it exists.
    def validation_property(field_name)
      false
    end

  end
end