class Post < Sofa
  def comments
    Comment.temp_view <<-JS
      if (doc.document_type == 'Comment' && doc.post_id == '#{self.id}') {
        emit(doc.created_at, doc)
      }
    JS
  end
  
  def self.get_by_slug(slug)
    results = self.temp_view <<-JS
      if (doc.document_type == 'Post' && doc.slug == '#{slug}') {
        emit(null, doc) 
      }
    JS
    results.first
  end
  
  def self.get_by_tags(*tags)
    unless tags.try(:any?)
      return self.all
    end
    
    tag_conditionals = tags.map{|t| "doc.tags.indexOf('#{t}') != -1"}.join(' && ')
    map = <<-JS
      if (doc.document_type == 'Post' && #{tag_conditionals}) {
        emit(doc.created_at, doc);
      }
    JS
    
    self.temp_view :map => map #, :keys => tags
  end
end
