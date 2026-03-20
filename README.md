*Process Closer*
This script is used to close processes across multiple workstations automatically as long as the name of the process is known.

*CreateAShortcut for A webportal.ps1*
This is a way to automaticly create a shortcut to a specific webpage once the script gets deployed accross the target workstations.

*itmdm64-Deletion.ps1*
This script was created in reponse to the article named "Patch Tuesday: Windows users hacked due to legacy fax modem driver" by Edward Targett
He explains that there is a legacy file that appears on systems that can be used to hack stuff. This file is present on most windows computers.

This was created to delete a vulnerability at the location.
C:\Windows\System32\DriverStore\FileRepository\mdmagm64.inf_amd64_596c8fd6d9bb0499\ltmdm64.sys
This was designed to be used with an RMM.
It creates a report that includes the computer name it checks if the file exists at the location and it lets you know if you deleted the file.
