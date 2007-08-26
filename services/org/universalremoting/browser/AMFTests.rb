#Copyright (c) 2007 Aaron Smith (aaron@rubyamf.org) - MIT License

#Simple Person class for VO Testing
class Person
  attr_accessor :name
  attr_accessor :phone
end

require 'rubygems'
require 'active_record'
require 'mysql'
require 'date'
require 'ostruct'
require 'rubyful_soup'

require RUBYAMF_CORE + 'util/net_debug'
require RUBYAMF_HELPERS + 'fault_object'
require RUBYAMF_HELPERS + 'active_record_connector'
require RUBYAMF_SERVICES + 'org/universalremoting/browser/support/ar_models/datas'

#this class implements the universal remoting browser tests that are bundled with the application
class AMFTests
  
  #notifies the browser that were AMFTests capable
  def ping
    true
  end
  
  include ActiveRecordConnector
  
  def _authenticate(user,pass)
    #return FaultObject.new(1, 'Authentication Failed')
    #@auth = true if user != false && pass != false
  end
  
  def before_filter
    #return false
    #return FaultObject.new(1, 'Authentication Failed')
    #if !@auth then return FaultObject.new(1, 'Authentication Failed') end
    #ar_connect(RUBYAMF_SERVICES + 'org/universalremoting/browser/test.yaml')
  end
  
  
  #Test Flash8 Net Debug capabilities
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
	
	#Get a custom fault object
	def getFaultObject
	  return FaultObject.new(3, "This is an error object")
	end
	
	#Nil
	def getNil
		nil
	end
	
	#true
	def getTrue
		true
	end
	
	#false
	def getFalse
		false
	end
	
	#empty sting
	def getEmpty
	  ""
	end
	
	#integer
	def getInteger
	  Integer(1000)
	end
	
	#fixNum
	def getFixNum
		100000
	end
	
	#BigNum
	def getBigNum
		100000000000000
	end
	
	#float
	def getFloat
		-0.879327948723987423987
	end
	
	#string
	def getString
	  "Yips Is Ill"
	end
	
	#special chars string
	def getWackyString
		'l^*&^(*(&(&(*&^fds><?<?.,/./,f65akjaslk --- 9i8775 ++{}{\\"?>"?'
	end
	
	#time
	def getTime
		Time.now
	end
	
	#date
	def getDate
		return Date.new(2007, 8, 1)
	end
	
	#array
	def getArray
		array2 = [24, "erick is"]
		array = [-34, "Help me Out", nil, array2, 78.45]
		array
	end
	
	#mixed array
	def getHash
		hash = Hash.new
		hash["result"] = "RUBYAMF"
		hash[0] = "TEST"
		hash
	end
	
	#object
	def getObject
	  o = OpenStruct.new
	  o.name = "Aaron"
	  o.one = "Smith"
	  o
	end
	
	#mixed ARray
	def getMixedArray
		[false, true, "AMF4R", getBigNum, getFloat, getString, getFixNum, getXML, getWackyString, getNil, getArray, getDate, getTime]
	end
	
	#mixed hash
	def getMixedHash
	  h = {}
	  h['d'] = getDate
	  h['t'] = getTime
	  h['b'] = true
	  h['b1'] = false
	  h['bn'] = getBigNum
	  h[0] = 'hello'
	  h[3] = 'whatever'
	  h
	end
		
	#xml
	def getXML
		string = '<mydoc><someelement>Text, text, text</someelement></mydoc>'
		doc = BeautifulSoup.new(string);
		doc
	end
	
	#mysql recordset
  def getMysqlResult
	  @con = Mysql.connect("localhost","root","")
		@con.select_db("rubyamf")
    return @con.query("SELECT * FROM datas")
  end
	
  #AR result set
	def arGetMultiple(o = nil)
		return Datas.find(:all)
	end
	
  #Single AR result 
	def arGetSingle(ob = nil)
	  return Datas.find(105511)
	end

  #VO
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
	
	
	#################OTHER
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
	  puts x.inspect
	  return r
	end
	
	def testSession
	  return true
	end
	
end