###--------------------------------------------------------------------------------------------------------------------------------------------------------------
###--------------------------------------------------------------------------------------------------------------------------------------------------------------
###
##
#
#		Script to get the Current job titles from a list of usernames within an input file.
#
#		Neil Grevitt - August 2015
#
##
###
###--------------------------------------------------------------------------------------------------------------------------------------------------------------
###--------------------------------------------------------------------------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Set variable $data to hold the input file details
#
# Include a count variable, and initialise
#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# The Input file must be in .csv format, and include the following details:
# 
#	employeename,jobtitle
#	<UserlogonID>,Text String
# 	<UserlogonID>,Text String
#
#  Note: This is exactly the same file used for the getjobtitles.ps1 script, however, getjobtitles only uses the first column, employeename.
#
#
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$data = import-csv -path pajobtitles.csv
$count = 0


#--------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Start the loop to loop through each line of the input file in turn. Everything inside the loop will happen to each line in turn.
# Fails may not be obvious.
#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------

foreach ($user in $data){

#--------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Sets the input line values to employee and jobtitle for use in the actual command below.
#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------


$employee = $user.employeename
$JobTitle = $user.jobtitle

#--------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Increment Count
#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------

$count++

#--------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Command to do the work. Takes the first value for input into samaccountname/logonname then the jobtitle for the actual change.
# This command uses the pipe to setup the user to change (get-aduser), then action the change (set-aduser)
# Our rollback here is to run and save the getjobtitles.ps1 script. This was run before the change, the result is in the file: jobtitles.txt which is in the same folder as this script.
#
# CHANGE: Changed the script to change the description field to the same value as the jobtitle.
#
# Get-ADUser Help: https://technet.microsoft.com/en-us/library/ee617241.aspx
#
# Set-ADUser Help: https://technet.microsoft.com/en-us/library/ee617215.aspx
#
# Further inspiration:
# http://www.adamfowlerit.com/2014/08/16/updating-active-directory-from-a-csv/ 
#
#
# Changes Jobtitle first, then description, both use the same variable $jobtitle
#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------

Get-ADUser -Filter {SamAccountName -eq $employee} | Set-ADUser -Title $jobtitle
Get-ADUser -Filter {SamAccountName -eq $employee} | Set-ADUser -Description $jobtitle

#--------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Troubleshooting screen output.
#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------

write-host "Processing $employee Changing jobtitle to: $jobtitle"

}

