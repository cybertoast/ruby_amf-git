#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License

require 'app/amf'
include RUBYAMF::AMF

#Adapt an active record into a flash recordset.
class ActiveRecordAdapter
	
	def use_adapter?(results)
	  begin
	    if (results.class.superclass.name.to_s == 'ActiveRecord::Base' || results[0].class.superclass.name == 'ActiveRecord::Base')
		    return true
      end
      false
    rescue Exception => e
      false
    end
	end
	
	def run(results)
	  if results.class.to_s == 'Array' && results[0].class.superclass.name == 'ActiveRecord::Base' #wathc for multiple active records
		  results = run_multiple(results)
		elsif results.class.superclass.name.to_s == 'ActiveRecord::Base' 	#watch for a single active record (User.find(1))
      results = run_single(results)
    end
    return results
	end
	
	def run_multiple(results)
	  #handle ActiveRecord errors
		if !results[0].errors.empty?
	    results[0].errors.each do |k,v|
	      raise RUBYAMFException.new(RUBYAMFException.ACTIVE_RECORD_ERRORS, "#{k} #{v}")
	      break
	    end
	  end
	  
		column_names = results[0].class.column_names #store the column names
		row_count = results.length #get the number of rows in the Mysql::Result
		initial_data = Array.new #payload holder
		
		begin
			0.upto(row_count) do |i|
				row = []
				column_names.each do |key|
					row << results[i].attributes[key]
				end
				initial_data[i] = row
			end
		rescue Exception => te
      #don't do anything, it works itself out
		end

		asrecordset = ASRecordset.new(row_count,column_names,initial_data)
		results = asrecordset
	  return results
	end
	
	def run_single(results)
	  #handle active record errors
	  if !results.errors.empty?
	    results.errors.each do |k,v|
	      raise RUBYAMFException.new(RUBYAMFException.ACTIVE_RECORD_ERRORS, "#{k} #{v}")
	      break
	    end
	  end
	  
		column_names = results.class.column_names #store the column names
		initial_data = Array.new #payload holder
		begin
				row = []
				column_names.each do |key|
					row << results.attributes[key]
				end
				initial_data << row
		rescue Exception => e
		end
		asrecordset = ASRecordset.new(1,column_names,initial_data)
		result = asrecordset;
		return result
	end
end