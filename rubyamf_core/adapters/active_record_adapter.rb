require 'ostruct'

class ActiveRecordAdapter

  #should we use this adapter for the result type
  def use_adapter?(results)
    if(use_multiple?(results) || use_single?(results))
      return true
    end
    false
  end
  
  #run the results through this adapter
  def run(results)
    if(use_multiple?(results))
      results = run_multiple(results)
    else
      results = run_single(results)
    end
    results
  end

  #is the result an array of active records
  def use_multiple?(results)
    if(results.class.to_s == 'Array' && results[0].class.superclass.to_s == 'ActiveRecord::Base')
      return true
    end
    false
  end

  #is this result a single active record?
  def use_single?(results)
    if(results.class.superclass.to_s == 'ActiveRecord::Base')
      return true
    end
    false
  end

  #get any associated data on an AR instance (from :include)
  def get_associates(arinstance)
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
    possibles = arinstance.instance_variables.clone
    possibles.each do |k|
      if keys.include?(k[1,k.length])
        next
      end
      finals << k if k != '@attributes'
    end
    finals
  end

  #get column_names for an active_record
  def get_column_names(arinstance)
    return arinstance.attributes.map{|k,v| k}
  end

  #run the data extaction process on an array of AR results
  def run_multiple(um)
    initial_data = []
    column_names = get_column_names(um[0])
    num_rows = um.length

    c = 0
    0.upto(num_rows - 1) do
      o = OpenStruct.new
      class << o
        def id
          return self.amf_id
        end
        def id=(val)
          self.amf_id = val
        end
      end
      
      #turn the outgoing object into a VO if neccessary
      map = VoUtil.get_vo_definition_from_active_record(um[0].class.to_s)
      if map != nil
        o._explicitType = map[:outgoing]
      end
      
      #first write the primary "attributes" on this AR object
      column_names.each_with_index do |v,k|
        k = column_names[k]
        val = um[c].send(:"#{k}")
        eval("o.#{k}=val")
      end
      
      associations = get_associates(um[0])
      if(!associations.empty?)
        #associations = get_associates(um[0])
        #now write the associated models with this AR
        associations.each do |associate|
          na = associate[1, associate.length]
          ar = um[c].send(:"#{na}")
          if !ar.empty? && !ar.nil?
            if(use_single?(ar))
              initial_data_2 = run_single(ar)   #recurse into single AR method for same data structure
            else
              initial_data_2 = run_multiple(ar) #recurse into multiple AR method for same data structure
            end
            eval("o.#{na}=initial_data_2")
          end
        end
      end
      c += 1
      initial_data << o
    end
    initial_data
  end

  #run the data extraction process on a single AR result
  def run_single(us)
    initial_data = []
    column_names = get_column_names(us)
    num_rows = 1
    
    c = 0
    0.upto(num_rows - 1) do
      o = OpenStruct.new
      class << o
        def id
          return self.amf_id
        end
        def id=(val)
          self.amf_id = val
        end
      end

      #turn the outgoing object into a VO if neccessary
      map = VoUtil.get_vo_definition_from_active_record(us.class.to_s)
      if map != nil
        o._explicitType = map[:outgoing]
      end
      
      #first write the primary "attributes" on this AR object
      column_names.each_with_index do |v,k|
        k = column_names[k]
        val = us.send(:"#{k}")
        eval("o.#{k}=val")
      end
      
      associations = get_associates(us)
      if(!associations.empty?)
        #now write the associated models with this AR
        associations.each do |associate|
          na = associate[1, associate.length]
          ar = us.send(:"#{na}")
          if !ar.empty? && !ar.nil?
            if(use_single?(ar))
              initial_data_2 = run_single(ar)   #recurse into single AR method for same data structure
            else
              initial_data_2 = run_multiple(ar) #recurse into multiple AR method for same data structure
            end
            eval("o.#{na}=initial_data_2")
          end
        end
      end
      if us.single?
        initial_data = o
      else
        initial_data << o
      end
      c += 1
    end
    initial_data
  end  
end


=begin
TESTING = true
require 'rubygems'
require 'active_record'
require '../../services/org/universalremoting/browser/support/ar_models/user'
require '../../services/org/universalremoting/browser/support/ar_models/address'
require '../util/active_record'

ar = ActiveRecordAdapter.new

ActiveRecord::Base.establish_connection(:adapter => 'mysql', :host => 'localhost', :password => '', :username => 'root', :database => 'ar_rubyamf_testings')

### multiple results, including some other associations
mult = User.find(:all, :include => :addresses)

### single result
sing = User.find(402, :include => :addresses)

final = ar.run_multiple(mult)
puts "MULTIPLE -> RESULTS"
puts '--------------'
puts final.inspect
puts '--------------'
puts final[0].inspect

puts "\n\n"

finals = ar.run_single(sing)
puts "SINGLE -> RESULT"
puts '--------------'
puts finals.inspect
puts '--------------'
puts finals[0].inspect
=end