# vim: set tw=0: http://momentary.eu/

# Joseph Harriott - Tue 10 May 2016
# Sync/backup my personal files to/from HPP:11-n012na
# PS C:\Users\Joseph> E:\Files\IT_stack\SyncPortableDrives\RobocopyHPP.ps1
# suffix these lines with /l to just list Robocopy's diagnosis without making any changes
# ----------------------------------------------------------------------------------------------
# E: MQ01ABF050
# G: Samsung M3
# H: K16GB500

$backupFolder = "G:\Robocopy-backup-HPP"
$FoldersArray = @(
  # first element of each row allows for that row to be switched off, by setting to 0
  (0,"E:\DropboxFiles\Close","$backupFolder\Close","H:\Close"),
  (0,"E:\DropboxFiles\Copied","$backupFolder\Copied","G:\Dr_Copied"),
  (0,"E:\DropboxFiles\Further","$backupFolder\Further","H:\Further"),
  (1,"E:\DropboxFiles\Now","$backupFolder\Now","H:\Now"),
  (1,"E:\DropboxFiles\Photos","$backupFolder\Photos","G:\Dr_Photos"),
  (0,"E:\DropboxFiles\Pointure_23","$backupFolder\Pointure_23","G:\Dr_Pointure_23"),
  (0,"E:\Files","$backupFolder\Files","G:\Files"),
  (0,0,0) # dummy row
  )

# Dialogue with myself:
""
"Joseph, this Powershell script will use Robocopy to mirror your personal folders."
[System.Console]::BackgroundColor = 'DarkCyan'
[System.Console]::ForegroundColor = 'White'
""
$reply = Read-Host "Do you want to backup (b), or mirror TO (T) portable drives (or simulate (t)),  or mirror FROM (F) (or simulate (f))? "
[System.Console]::ResetColor()
""

$simulate = ""
if ($reply -ceq "b") {"Okay, running backups to $backupFolder`n"}
  elseif ($reply -ceq "T") {
    [System.Console]::BackgroundColor = 'Blue'
    [System.Console]::ForegroundColor = 'White'
    ""
    $replyCheck = Read-Host "You want to go ahead and mirror changes TO external drives? "
    [System.Console]::ResetColor()
    ""
	if ( $replyCheck -ne "y" ) {exit}
  } elseif ($reply -ceq "t") {
	  "Okay, running simulation for `"mirror to external drives`"`n"
	  $simulate = "/l"
  } elseif ($reply -ceq "F") {
      [System.Console]::BackgroundColor = 'Yellow'
      [System.Console]::ForegroundColor = 'DarkBlue'
      ""
      $replyCheck = Read-Host "You want to go ahead and mirror changes FROM external drives? "
      [System.Console]::ResetColor()
      ""
  	if ( $replyCheck -ne "y" ) {exit}
  } elseif ($reply -ceq "f") {
	  "Okay, running simulation for `"mirror from external drives`"`n"
	  $simulate = "/l"
  } else { exit }

# Prepare a file to log all of the changes made:
$ChangesLog = $PSCommandPath.TrimEnd("ps1")+"log"
$ThisScript = $PSCommandPath.TrimStart($PSScriptRoot)
"vim: nowrap tw=0:" > $ChangesLog
"" >> $ChangesLog
"Changes made by $ThisScript`:" >> $ChangesLog
"" >> $ChangesLog

# Attempt to do the work requested:
foreach ($FolderControl in $FoldersArray) {
  # check that this folder is wanted:
  if ( $FolderControl[0] ) {
	# prepare the from & to folders:
    if ($reply -ceq "b") {
      $frFolder = $FolderControl[1]
      $toFolder = $FolderControl[2]
      if ( ! $(Try { Test-Path $toFolder.trim() } Catch { $false }) ) {
		  "Sorry, $toFolder  ain't there.`n"; continue }
	} else {
      if ( ! $(Try { Test-Path $FolderControl[3].trim() } Catch { $false }) ) {
		  "Sorry, "+$FolderControl[3]+"  ain't there.`n"; continue }
      if ($reply -eq "t") {
        $frFolder = $FolderControl[1]
        $toFolder = $FolderControl[3]
	  } else {
        $frFolder = $FolderControl[3]
        $toFolder = $FolderControl[1]
	  }
	}
	# ready to go ahead, prepare:
	$frFolder
    $toFolder
    $LogFile = $toFolder+".log"
    $LogFile
    $Command0 = "`"vim: nowrap tw=0:`" > $LogFile"
    $Command1 = "robocopy /mir $frFolder $toFolder /np /unilog+:$LogFile /tee $simulate"
	$Command1
	""
	# do the Robocopy:
    # iex $Command0
    # "" >> $LogFile
    # "$Command0; $Command1" >> $LogFile
    # iex $Command1
  }
}
""

# Sign off:
Write-Host "All done and logged individually, with all of the changes saved together to  $ChangesLog" -background darkcyan -foreground white
