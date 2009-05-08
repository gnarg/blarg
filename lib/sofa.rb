require 'ostruct'

class Sofa < OpenStruct
  class << self
    def get(id)
      raise ArgumentError.new("missing required id") if id.nil?
      begin
        document = COUCHDB.get(id)
        self.new(document)
      rescue RestClient::ResourceNotFound
        nil
      end
    end
    
    def create(attributes)
      returning(new(attributes)) do |product|
        product.save
      end  
    end
    
    def temp_view(map, reduce=nil)
      query = Hash === map ? map : { :map => map, :reduce => reduce }
      query[:map] = "function(doc) { #{query[:map]} }"
      query[:reduce] = "function (keys, values, rereduce) { #{query[:reduce]} }" if reduce
    
      COUCHDB.temp_view(query)['rows'].map do |row|
        self.new(row['value'])
      end    
    end
    
    def human_attribute_name(attribute)
      attribute.to_s.humanize.downcase
    end
    
    def all
      temp_view <<-JS
        if (doc.document_type == '#{self.name}') {
          emit(doc.created_at, doc)
        }
      JS
    end
  end

  # Custom initialize to support indifferent access to
  # attribute table
  def initialize(hash=nil)
    @table = HashWithIndifferentAccess.new
    
    for k,v in hash
      @table[k] = v
      new_ostruct_member(k)
    end if hash
  end
    
  def new_document?
    _id.blank?
  end
  
  alias_method :new_record?, :new_document?
  
  def save
    self.document_type = self.class.name
    attributes = self.to_hash
    
    time = Time.now.xmlschema
    attributes.update('created_at' => time) if new_document? && attributes['created_at'].blank?
    attributes.update('updated_at' => time)
    
    response = COUCHDB.save_doc(attributes)
    if response['ok']
      self._id = response['id']
    else
      errors.add_to_base("Unable to save #{self.class.name}.")
      false
    end
  end
  
  def merge(attrs)
    @table.merge!(attrs.with_indifferent_access)
  end
  
  def replace(attrs)
    %w(_id _rev created_at updated_at).each do |key|
      attrs[key] = @table[key] if @table.has_key?(key)
    end
      
    @table.replace(attrs.with_indifferent_access)
  end
  
  def clone
    self.class.new(
      @table.with_indifferent_access.except(*%w(_id _rev created_at updated_at))
    )
  end
  
  def reload
    replace(Product.get(id).to_hash)
  end
  
  def delete
    COUCHDB.delete_doc(self.to_hash)
  end
  
  def to_hash
    @table
  end
  
  def id
    @table['_id']
  end
  
  def revision
    @table['_rev']
  end
  
  def to_param
    id
  end
  
  def created_at
    Time.xmlschema(@table['created_at'])
  end
  
  def created_at=(time)
    @table['created_at'] = time.xmlschema
  end
  
  def updated_at
    Time.xmlschema(@table['updated_at'])
  end
  
  def updated_at=(time)
    @table['updated_at'] = time.xmlschema
  end
  
  def errors
    @errors ||= ActiveRecord::Errors.new(self)
  end
end