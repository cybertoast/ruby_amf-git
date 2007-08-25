require 'ostruct'

class ActiveRecordAdapter

  #should we use this adapter for the result type
  def use_adapter?(results)
    if(use_multiple?(results) || use_single?(results))
      return true
    end
    return false
  end
  
  #run the results through this adapter
  def run(results)
    if(use_multiple?(results))
      results = run_multiple(results)
    else
      results = run_single(results)
    end
    return results
  end

  #is the result an array of active records
  def use_multiple?(results)
    if(results.class.to_s == 'Array' && results[0].class.superclass.to_s == 'ActiveRecord::Base')
      return true
    end
    return false
  end

  #is this result a single active record?
  def use_single?(results)
    if(results.class.superclass.to_s == 'ActiveRecord::Base')
      return true
    end
    false
  end

  #find out if we have associates
  def associates?(arinstance)
    (arinstance.instance_variables.length > 1) ? true : false
  end

  #get any associated data on an AR instance (from :include)
  def get_associates(arinstance)
    finals = []
    possibles = arinstance.instance_variables.clone
    possibles.each do |k|
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
        #redefine id,id= methods so that we actually get correct id's
        def id
          return self.idd
        end
        def id=(v)
          self.idd = v
        end
      end
      
      #first write the primary "attributes" on this AR object
      column_names.each_with_index do |v,k|
        k = column_names[k]
        val = um[c].send(:"#{k}")
        eval("o.#{k}=val")
      end
      
      if VoUtils.getVoDefFromMappedRubyObj(um.class.to_s)
        o = VoUtil.getVoInstanceFromMappedRubyObj(um)
      end
    
      if(associates?(um[0]))
        associations = get_associates(um[0])
        #now write the associated models with this AR
        associations.each do |associate|
          na = associate[1, associate.length]
          ar = um[c].send(:"#{na}")
          if(use_single?(ar))
            initial_data_2 = run_single(ar)   #recurse into single AR method for same data structure
          else
            initial_data_2 = run_multiple(ar) #recurse into multiple AR method for same data structure
          end
          eval("o.#{na}=initial_data_2")
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
        #redefine id,id= methods so that we actually get correct id's
        def id
          return self.idd
        end
        def id=(v)
          self.idd = v
        end
      end
    
      #first write the primary "attributes" on this AR object
      column_names.each_with_index do |v,k|
        k = column_names[k]
        val = us.send(:"#{k}")
        eval("o.#{k}=val")
      end
    
      if(associates?(us))
        associations = get_associates(us)
        #now write the associated models with this AR
        associations.each do |associate|
          na = associate[1, associate.length]
          ar = us.send(:"#{na}")
          if(use_single?(ar))
            initial_data_2 = run_single(ar)   #recurse into single AR method for same data structure
          else
            initial_data_2 = run_multiple(ar) #recurse into multiple AR method for same data structure
          end
          eval("o.#{na}=initial_data_2")
        end
      end  
      c += 1
      initial_data << o
    end
    initial_data
  end
  
end


#require 'user'
#require 'address'

=begin
ActiveRecord::Base.establish_connection(:adapter => 'mysql', :host => 'localhost', :password => '', :username => 'root', :database => 'ar_rubyamf_testings')

### multiple results, including some other associations
mult = User.find(:all, :include => :addresses)

### single result
sing = User.find(1, :include => :addresses)

final = run_multiple(mult)
puts "MULTIPLE -> RESULTS"
puts '--------------'
puts final.inspect
puts '--------------'
puts final[0].inspect

puts "\n\n"

finals = run_single(sing)
puts "SINGLE -> RESULT"
puts '--------------'
puts finals.inspect
puts '--------------'
puts finals[0].inspect
=end