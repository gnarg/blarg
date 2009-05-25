module Sofa

  class Record < Resource    
    include Sofa::Validate

    before :save, :check_validations
  end
end