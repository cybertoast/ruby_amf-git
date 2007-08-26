#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License

class Person
  attr_accessor :name
  attr_accessor :phone
end

require 'rubygems'
require 'active_record'
require 'mysql'
require 'date'
require 'rexml/document'
require 'ostruct'
require 'rubyful_soup'
include REXML
require RUBYAMF_CORE + 'util/net_debug'
require RUBYAMF_SERVICES + 'org/rubyamf/amf/models/datas'
require RUBYAMF_SERVICES + 'org/rubyamf/amf/models/user'
require RUBYAMF_SERVICES + 'org/rubyamf/amf/models/address'
require $RUBYAMF_HELPERS + 'fault_object'
require $RUBYAMF_HELPERS + 'active_record_connector'

#simple data echoing tests
class AMFTesting
  
  include ActiveRecordConnector
  
  def _authenticate(user,pass)
    #return FaultObject.new(1, 'Authentication Failed')
    #@auth = true if user != false && pass != false
  end
  
  def before_filter
    #return false
    #return FaultObject.new(1, 'Authentication Failed')
    #if !@auth then return FaultObject.new(1, 'Authentication Failed') end
    ar_connect(RUBYAMF_SERVICES + 'org/rubyamf/amf/test.yaml')
  end
  
	def netDebug
    NetDebug.Trace(nil)
    NetDebug.Trace(true)
    NetDebug.Trace(false)
    NetDebug.Trace(getString)
    NetDebug.Trace(getWackyString)
    NetDebug.Trace(getArray)
    NetDebug.Trace(getMixedArray)
    NetDebug.Trace(getHash)
    NetDebug.Trace(getFixNum)
    NetDebug.Trace(getBigNum)
    NetDebug.Trace(getFloat)
    NetDebug.Trace(getXML)
    return true
	end
	
	def voPassThrough(myVo = nil)
	  #puts myVo.inspect
	  #return myVo
	  r = Person.new
	  r.name = "aaron"
	  r.phone = "789787"
	  
	  s = Person.new
	  s.name = "aaron"
	  s.phone = "789787"
	  
	  t = Person.new
	  t.name = "aaron"
	  t.phone = "789787"
	  x = [r,s,t,myVo]
	  return r
	end
	
	def testSession
	  return true
	end
	
	def getFaultObject
	  return FaultObject.new(3, "This is an error object")
	end
	
	def getNil
		nil
	end
	
	def getTrue
		true
	end
	
	def getFalse
		false
	end
	
	def getInteger
	  Integer(1000)
	end
	
	def getFixNum
		100000
	end
	
	def getBigNum
		100000000000000
	end
	
	def getFloat
		-0.879327948723987423987
	end
	
	def getString
	  #return Date.new.to_s
	  #DBErrorLogger.Log(["MyService:",'asdfasdfasdf'])
	  #ErrorNotifier.Send(@smtp, @to_email, @from_email,["MyService:\n",'asdfasdfasdf'])
	  "Yips Is Ill"
	end

  def getOpenStruct
    o = OpenStruct.new
	  o.name = 'aron'
	  o
  end
	
	def getWackyString
		'l^*&^(*(&(&(*&^fds><?<?.,/./,f65akjaslk --- 9i8775 ++{}{\\"?>"?'
	end
	
	def getTime
		Time.now
	end
	
	def getDate()
		return Date.new(2007, 8, 1)
	end
	
	def getArray
		array2 = [24, "erick is"]
		array = [-34, "Help me Out", nil, array2, 78.45]
		array
	end
	
	def getHash
		hash = Hash.new
		hash["result"] = "RUBYAMF"
		hash[0] = "TEST"
		hash
	end
	
	def getObject
	  o = OpenStruct.new
	  o.name = "Aaron"
	  o.one = "Smith"
	  o
	end
	
	def getMixedArray
		[false, true, "AMF4R", getBigNum, getFloat, getString, getFixNum, getXML, getWackyString, getNil, getArray, getDate, getTime]
	end
	
	def getMixedHash
	  h = {}
	  h['d'] = getDate
	  h['t'] = getTime
	  h['b'] = true
	  h['b1'] = false
	  h['bn'] = getBigNum
	  h
	end
		
	def getXML
		string = '<mydoc><someelement>Text, text, text</someelement></mydoc>'
		doc = BeautifulSoup.new(string);
		doc
	end	
	
  def getMysqlResult
	  @con = Mysql.connect("localhost","root","")
		@con.select_db("rubyamf")
    return @con.query("SELECT * FROM datas")
  end

	def getPeopleVOs
    people = [ 
      ["Alessandro", "Crugnola", "+390332730999", "alessandro@sephiroth.it"],
      ["Patrick", "Mineault", "+1234567890", "patrick@5etdemi.com"],
      ["Aaron", "Smifth", "+1234567890", "patrick@5etdemi.com"],
      ["Aaron", "Smith", "+1234567890", "patrick@5etdeffmi.com"],
      ["Patrick", "Minffeault", "+1234567890", "patrick@5etdemi.com"] 
    ]

    p = []

    people.each_with_index do |v,i|
      pers = Person.new
      pers.name = people[i][0] + people[i][1]
      pers.phone = people[i][2]
      p << pers
    end
    
    return p
	end
  
  #####ACTIVE RECORD TESTS
  def arGetEmpty
    return Datas.new
  end
	
	#get all rows in the 'datas' table
	def arGetMultiple(o = nil)
		return Datas.find(:all)
	end
	
	#get a single ActiveRecord::Base
	def arGetSingle(ob = nil)
	  return Datas.find(105511)
	end
	
	def getARWithAssociations
	  #return 44
	  puts "GET AR WITH ASSOCIATIONS"
	  r = User.find(:all, :include => :addresses)
	  puts r[0].id
	  puts r[0].send(:"id")
	  #r = User.find(:all)
	  return r
	end
	
	def receiveVOAsActiveRecord(myVO)
	  #myVO.save
	  puts myVO.inspect
	end
  
  def voAsAR(vo)
  end
	
  def arVOSave(vo)
  end
  
  def arVOUpdate(vo)
  end

end