#This Install script is for Rails Plugin Installation. If using the RubyAMF Lite this is not needed.
begin
  require 'fileutils'
  Dir.mkdir("./config/rubyamf/")
  FileUtils.copy_file("./vendor/plugins/rubyamf/rubyamf_core/rails_installer_files/rubyamf_controller.rb","./app/controllers/rubyamf_controller.rb",false)
  FileUtils.copy_file("./vendor/plugins/rubyamf/rubyamf_core/rails_installer_files/vo_config.rb", "./config/rubyamf/vo_config.rb", false)
  FileUtils.copy_file("./vendor/plugins/rubyamf/rubyamf_core/rails_installer_files/adapters_config.rb", "./config/rubyamf/adapters_config.rb", false)
  FileUtils.copy_file("./vendor/plugins/rubyamf/rubyamf_core/rails_installer_files/crossdomain.xml","./public/crossdomain.xml", false)
  
  mime = true
  File.open("./config/environment.rb","r") do |f|
    while line = f.gets
      if line.match(/application\/x-amf/)
        mime = false
      end
    end
  end
  
  if mime
    File.open("./config/environment.rb","a") do |f|
      f.puts "\nMime::Type.register \"application/x-amf\", :amf"
    end
  end
rescue Exception => e
  puts "ERROR INSTALLING RUBYAMF: " + e.message
end