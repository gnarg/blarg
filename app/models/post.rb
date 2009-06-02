class Post < Sofa::Record
  validates_present :slug
  validates_present :title
  validates_present :author
  validates_present :body

  before :validations, :convert_tags_to_array

  def convert_tags_to_array
    tags = @table['tags']
    if tags && tags.is_a?( String )
      if tags.size > 0
        @table['tags'] = tags.split( ' ' )
      else
        @table['tags'] = nil
      end
    else
      @table['tags'] = tags
    end

    true
  end

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
  
  def self.get_all_tags
    map = <<-JS
      function(doc) {
        if (doc.document_type == 'Post' && doc.tags) {
          doc.tags.forEach(function(tag) {
            emit(tag, 1);
          });
        }
      }
    JS
      
    reduce = <<-JS
      function(keys, values) {
        return sum(values);
      }
    JS
      
    result = COUCHDB.temp_view({:map => map, :reduce => reduce}, {:group => true})['rows']
    result.map{|r|r['key']}
  end
end
