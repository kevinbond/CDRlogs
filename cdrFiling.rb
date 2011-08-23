require 'net/ftp'
require 'json'


#create a ftp reference
ftp = Net::FTP.new

#connect to voxeo
ftp.connect("ftp.voxeo.net")

#login with Tropo credentials
ftp.login("username","password")

#Go to the logs directry
ftp.chdir("/logs")

#get a list of all of the logs
list = ftp.nlst

#saving a text file of the newest log to the computer
ftp.gettextfile(list[list.length - 1])

#opening the saved file
file = File.open("/path/to/file/#{list[list.length - 1]}")

#reading the entire file
contents = file.read

#closing the file
file.close

#opening a file that will hold all of the CDR's
cdrFile = File.open("CDR.txt", "a")

#spliting the file into an array
check = contents.split("CDR ")

#searching through each array for the CDR's
check.each do |l|
  
  #If l[3] == 'h', it is a cdr
  if l[3] == "h"
    #saving the cdr
    cdr = l[0..(l.rindex("\"}\n") + 1)]
    #parsing the cdr to JSON
    cdr = JSON.parse(cdr)
    #savinf the CDR to the file
    cdrFile.write(cdr)
    cdrFile.write("\n\n")
  end
end
#finally, close the file
cdrFile.close