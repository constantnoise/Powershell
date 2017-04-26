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

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Set variable $data to hold the input file details
#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# The Input file must be in .csv format, and include the following details:
# 
#	employeename,jobtitle
#	<UserlogonID>,Text String
# 	<UserlogonID>,Text String
#
# Note: This is exactly the same file used for the setjobtitles.ps1 script, but only uses the first column, employeename.
#
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$data = import-csv -path pajobtitles.csv
$count = 0

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Start the loop to loop through each line of the input file in turn. Everything inside the loop will happen to each line in turn.
# Fails may not be obvious.
#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

foreach ($user in $data){

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Sets the input line values to employee and jobtitle for use in the actual command below. Jobtitle is not needed in this get script.
#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$employee = $user.employeename

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# $JobTitle = $user.jobtitle
#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Command. Takes employee name from file as above. pipes the output to format-table to format name and title, then pipes to out-file which creates and appends the text file.
# Get-ADUser Help: https://technet.microsoft.com/en-us/library/ee617241.aspx
#
#  Build a PSObject full of wonderful data, by $MyObject = blahblahblah...
#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$currenttitle = get-aduser -Filter {SamAccountName -eq $employee} -properties title | select Title 
$currentdescription = get-aduser -Filter {SamAccountName -eq $employee} -properties description | select Description

Get-ADUser -Filter {SamAccountName -eq $employee} -Properties Name, SamAccountName, Title, Description | Format-Table Name, Title, Description | out-file Jobtitlesnew.txt -append

$count++

# $MyObject = 

# $Header = @"
# <style>
# TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
# TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
# TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
# </style>
# "@
 
# $MyObject | Select Name, SamAccountName, Title | ConvertTo-HTML -Head $Header | out-file MyReport.html -append




# Removed for HTML Test
# | Format-Table Name, Title | out-file Jobtitles.txt -append


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Troubleshooting screen output.
#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

write-host "Processing $employee Current title  $currenttitle $currentdescription"



}

Write-host "Processed $count rows."