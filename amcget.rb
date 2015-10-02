## Crafted (c) 2013~2014 by ICC - Inatel Competence Center
## Prepared : Roberto Nogueira
## File     : amcget.rb
## Version  : PA01
## Date     : 2015-09-17
## Project  : INNOVATION_-_AMC_Design_on_Rails
##
## Purpose  : AMC lift design controlled by VCS and related tools

require 'curb'
require 'hpricot'

c = Curl::Easy.new("https://mhweb.ericsson.se/mhweb/servlet/servletCorrView?corrid=R01MCXJN-5611")
c.http_auth_types = :basic
c.ssl_verify_peer = false
c.username = 'xrobnog'
c.password = 'Zoateri#22.'
c.perform

doc = Hpricot.parse(c.body_str)
text = (doc/"//*/text()")

lines = text.join("\n").split(/\r?\n|\r/)

@status_data = {:start => "Status Data", :end   => "Description"}
@description = {:start => "Description", :end => "Trouble Effects"}
@trouble_effects = {:start => "Trouble Effects", :end => "Trouble Description"}
@trouble_description = {:start => "Trouble Description", :end => "Test Instruction"}
@test_instruction = {:start => "Test Instruction", :end => "PLEX Solution"}
@plex_solution = {:start => "PLEX Solution", :end => "ASA Solution"}
@asa_solution = {:start => "ASA Solution", :end => "Loading/SPAC Criteria"}
@loading_spac_criteria = {:start => "Loading/SPAC Criteria", :end => "Enclosures"}
@enclosures = {:start => "Enclosures", :end => "Notebook"}
@notebook = {:start => "Notebook", :end => "Validation Result"}

def amc_get(lines, chapter)
  cmd_found = false
  result=[]
  lines.each_index do |i|
    if lines[i] =~ /\S#{chapter[:start]}/ then
      cmd_found = true
      result << lines[i].chop
    else
      if cmd_found  then
        if (lines[i+1] =~ /\S#{chapter[:end]}/) or (lines[i+1] == nil) then
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

file = File.new("R01MCXJN-5611.txt", "w+")
  file.puts text.join("\n")
file.close

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


