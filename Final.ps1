$SourcePath = "E:\Dropbox\Dropbox (ASU)\_Projects\Powershell practice\Mail Merge\Book3.csv"
$Users = Import-Csv -Path $SourcePath

foreach ($User in $Users) {
# Send email as a HTML body. 
$smtpServer = "smtp.asu.edu" 
$MailFrom = "RTSHelp@asu.edu" 
$mailto = $User.email
$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $MailFrom 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = $User.IR + " *RESPONSE REQUIRED* - Windows 10 update needed."
$MailTextT =  Get-Content  -Path "E:\Dropbox\Dropbox (ASU)\_Projects\Powershell practice\Mail Merge\message.html"
$msg.Body = $MailTextT 
$smtp.Send($msg) }