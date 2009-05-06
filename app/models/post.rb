class Post < Sofa
  def comments
    Comment.temp_view <<-JS
      if (doc.document_type == 'Comment' && doc.post_id == '#{self.id}') {
        emit(doc.created_at, doc)
      }
    JS
  end
end
