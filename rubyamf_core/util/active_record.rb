#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License
class ActiveRecord::Base
  
  @rubyamf_single_ar = false
  #these three methods are used when returning an ActiveRecord#as_single!
  def as_single!
    @rubyamf_single_ar = true
    self
  end
  def single!
    @rubyamf_single_ar = true
    self
  end
  def single?
    @rubyamf_single_ar
  end
  
  #get any associated data on an AR instance (from :include)
  def get_associates
    keys = ['==','===','[]','[]=','abstract_class?','attr_accessible',
    'attr_protected','attribute_names','attribute_present?','attributes',
    'attributes=','attributes_before_type_cast','base_class','benchmark',
    'class_of_active_record_descendant','clear_active_connections!',
    'clear_reloadable_connections!','clone','column_for_attribute',
    'column_names','columns','columns_hash','compute_type','connected?',
    'connection','connection','connection=','content_columns',
    'count_by_sql','create','decrement','decrement!','decrement_counter',
    'delete','delete_all','destroy','destroy','destroy_all','eql?',
    'establish_connection','exists?','find','find_by_sql','freeze','frozen?',
    'errors','new_record_before_save','rubyamf_single_ar',
    'has_attribute?','hash','id','id=','increment','increment!',
    'increment_counter','inheritance_column','new','new_record?','new_record','primary_key',
    'readonly?','reload','remove_connection','require_mysql',
    'reset_column_information','respond_to?','sanitize_sql','sanitize_sql_array',
    'sanitize_sql_hash','save','save!','serialize','serialized_attributes',
    'set_inheritance_column','set_primary_key','set_sequence_name',
    'set_table_name','silence','table_exists?','table_name','to_param',
    'toggle','toggle!','update','update_all','update_attribute',
    'update_attributes','update_attributes!','with_exclusive_scope','with_scope']
    finals = []
    possibles = self.instance_variables.clone
    possibles.each do |k|
      if keys.include?(k[1,k.length])
        next
      end
      finals << k if k != '@attributes'
    end
    finals
  end
  
  #get column_names for an active_record
  def get_column_names
    return self.attributes.map{|k,v| k}
  end
  
  def to_update_hash
    o = {}
    column_names = self.get_column_names
    
    #first write the primary "attributes" on this AR object
    column_names.each_with_index do |v,k|
      k = column_names[k]
      val = us.send(:"#{k}")
      eval("o.#{k}=val")
    end
    
    associations = self.get_associates
    if(!associations.empty?)
      #now write the associated models with this AR
      associations.each do |associate|
        na = associate[1, associate.length]
        ar = self.send(:"#{na}")
        if !ar.empty? && !ar.nil?
          if(ar.class.superclass.to_s == 'ActiveRecord::Base')
            update_hash = ar.to_update_hash   #recurse into single AR method for same data structure
          elsif(ar[0].class.superclass == 'ActiveRecord::Base')
            update_hash = {}
            ar.each do |a|
              u = a.to_update_hash
              update_hash << u
            end
          end
          eval("o.#{na}=update_hash")
        end
      end
    end
    o
  end
  
end