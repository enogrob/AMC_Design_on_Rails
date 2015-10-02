#require 'curb'
#require 'hpricot'
#
#c = Curl::Easy.new("https://mhweb.ericsson.se/mhweb/servlet/servletCorrView?corrid=R01MCXJN-5611")
#c.http_auth_types = :basic
#c.ssl_verify_peer = false
#c.username = 'xrobnog'
#c.password = 'Zoatsea#22.'
#c.perform
#
#doc = Hpricot.parse(c.body_str)
#text = (doc/"//*/text()")
#
#file = File.new("R01MCXJN-5611.txt", "w+")
# file.puts text.join("\n")
#file.close

File.open("R01MCXJN-5611.txt", "r") do |file|
  cmd_found = false
	result=[]
	lines = file.readlines
	lines.each_index do |i|
      if lines[i] =~ /\SPLEX Solution/ then
        cmd_found = true
        result << lines[i].chop
      else
        if cmd_found  then
          if (lines[i+1] =~ /\SASA Solution/) or (lines[i+1] == nil) then
              result << lines[i].chop
              puts result
            	break
          else
            	result << lines[i].chop
          end
        end
      end
  end
end
