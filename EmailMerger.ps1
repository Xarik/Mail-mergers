$SourcePath = "path\to\Book3.csv"
$Users = Import-Csv -Path $SourcePath

foreach ($User in $Users) {
# Send email as a HTML body. 
$smtpServer = "smtp.mail.com" 
$MailFrom = "an@email.com" 
$mailto = $User.email
$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $MailFrom 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "this is a message for " + $User.name
$MailTextT =  Get-Content  -Path "C:Your\path\here.html"
$msg.Body = $MailTextT 
$smtp.Send($msg) }
##############Updates 7/30/2020 including inline email written entirely in PS (Specifically, this is built for an uninstaller that emails us a specific set of folder names)
##############Additionally, this includes a link inside the body of the email that generates an email with inserted variables for ease of use
#gather user and device information

$currentUser = (Get-CimInstance -Class Win32_Process -Filter “Name like 'explorer%'” | Invoke-CimMethod -MethodName GetOwner).User
$pcUser = $currentUser | Select-Object -First 1
$CIMHostname = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty DNSHostname
$Login = gci -Path "C:\Users\$($pcuser)\AppData\Roaming\THERESTOFMYPATH" | where {($_.extension -like "") -and ($_.name -notlike "*FILTER HERE*")} | select -ExpandProperty name
$Login1 = $login -join '<br />' #Folder info - This variable is for the HTML email
$login2 = $login -join '%20'    #Folder info - This variable is for the UTF-8 (Unicode) email [See generated link]
 
#configure email settings
$fromAddress = "YOURSMPTSERVERADDRESS@HERE.COM"
$toAddressList = "YOUR@EMAIL.COM"
$smtpServerAddress = "smtp.whatever.whatever"
$EmployeeEmail = "<a href='mailto:ADDITIONALRECIPIENTFORINTERNALUSE@email.com?subject='>employeename</a>"
$messageSubject = "PROGRAM Uninstalled - $CIMHostname ($pcuser) - NOTICE"

    #Generate new email message for link
    $NewMail = "<a href='mailto:EMAIL@EMAIL.COM?subject=APPLICATION%20Uninstalled%20-%20$CIMHostname%20($pcuser)%20-%20NOTICE&body=Good%20Evening,%20our%20records%20indicate%20that%20APPLICATION%20was%20uninstalled%20from%20this%20device/user%0A%0AUser%20-%20$pcuser%0A%0ADevice%20-%20$CIMHostname%0A%0AAssociated%20Username(s)%0A%0A$login2'>Click here to send the above information to EMPLOYEE NAME</a>"


$messageBody ="NOTICE - APPLICATION Uninstalled from $CIMHostname ($pcuser) - Please email $EmployeeEmail with this information:<br /><br />User - $pcuser<br /><br />Device - $CIMHostname<br /><br />Associated Username(s) - <br />$login<br /><br />$newmail"

######################################################
# Send Email
######################################################

Send-MailMessage -To $toAddressList -From $fromAddress -Subject $messageSubject -SmtpServer $smtpServerAddress -BodyAsHtml $messageBody
