class Comment < Sofa::Record  
  validates_present :body

  def self.find_all
    self.temp_view <<-JS
      if (doc.document_type == 'Comment') {
        emit(doc.created_at, doc)
      }
    JS
  end

  def self.find_all_unapproved
    self.temp_view <<-JS
      if (doc.document_type == 'Comment' && doc.approved != true) {
        emit(doc.created_at, doc)
      }
    JS
  end

end
