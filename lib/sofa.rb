module Sofa

  class Record < Resource
    include Sofa::Hook
    include Sofa::Validate
  end
end