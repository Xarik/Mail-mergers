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
