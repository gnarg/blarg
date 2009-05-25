class Comment < Sofa::Record  
  validates_present :body
end
