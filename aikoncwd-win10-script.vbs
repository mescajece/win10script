Set oADO = CreateObject("Adodb.Stream")
Set oWSH = CreateObject("WScript.Shell")
Set oNET = CreateObject("WScript.Network")
Set oAPP = CreateObject("Shell.Application")
Set oFSO = CreateObject("Scripting.FileSystemObject")
Set oWEB = CreateObject("Microsoft.XMLHTTP")
Set oWMI = GetObject("winmgmts:\\.\root\CIMV2")
Set oARG = WScript.Arguments

currentVersion = "5.0"

Call ForceConsole()
Call showBanner()
Call printf(" Comprobando sistema Windows 10 y privilegios...")
Call checkW10()
Call runElevated()
Call printf(" Privilegios de Administrador OK!")
Call printf(" Comprobando actualizaciones en GitHub...")
Call updateCheck()
Call showMenu(1)


'Win+U = cmd.exe
'reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\utilman.exe" /v "Debugger" /t REG_SZ /d "cmd.exe" /f > NUL 2>&1

Function updateCheck()
	Wait(1)
	oWEB.Open "GET", "https://raw.githubusercontent.com/aikoncwd/win10script/master/updateCheck", False
	oWEB.Send

	printf ""
	printf " > Version actual: " & currentVersion
	printf " > Version GitHub: " & oWEB.responseText
	ne = CDbl(Replace(oWEB.responseText, vbcrlf, ""))

	If ne > CDbl(currentVersion) Then
		printl "   Deseas actualizar el script? (s/n): "
		res = scanf()
		If res = "s" Then
			printf ""
			printl " > Descargando nueva version desde GitHub... "
			oWEB.Open "GET", "https://raw.githubusercontent.com/aikoncwd/win10script/master/aikoncwd-win10-script.vbs", False
			oWEB.Send

			Set F = oFSO.CreateTextFile(WScript.ScriptFullName, 2, True)
				F.Write oWEB.responseText
			F.Close
			printf "OK!"
			oWSH.Run WScript.ScriptFullName
			WScript.Quit
		End If
	Else
		printf "   Tienes la ultima version"
		printf "   Iniciando el script..."
		Wait(2)
	End If
	'WScript.Quit
End Function


oWEB.Open "GET", "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts", False
oWEB.Send

With oADO
	.Type = 1
	.Open
	.Write oWEB.responseBody
	.SaveToFile "C:\raw_host", 2
End With

Set F = oFSO.OpenTextFile("C:\raw_host", 8)
	F.WriteLine "#Antimalware Links"
	F.WriteLine "0.0.0.0 tracking.opencandy.com.s3.amazonaws.com"
	F.WriteLine "0.0.0.0 media.opencandy.com"
	F.WriteLine "0.0.0.0 cdn.opencandy.com"
	F.WriteLine "0.0.0.0 tracking.opencandy.com"
	F.WriteLine "0.0.0.0 api.opencandy.com"
	F.WriteLine "0.0.0.0 api.recommendedsw.com"
	F.WriteLine "0.0.0.0 installer.betterinstaller.com"
	F.WriteLine "0.0.0.0 installer.filebulldog.com"
	F.WriteLine "0.0.0.0 d3oxtn1x3b8d7i.cloudfront.net"
	F.WriteLine "0.0.0.0 inno.bisrv.com"
	F.WriteLine "0.0.0.0 nsis.bisrv.com"
	F.WriteLine "0.0.0.0 cdn.file2desktop.com"
	F.WriteLine "0.0.0.0 cdn.goateastcach.us"
	F.WriteLine "0.0.0.0 cdn.guttastatdk.us"
	F.WriteLine "0.0.0.0 cdn.inskinmedia.com"
	F.WriteLine "0.0.0.0 cdn.insta.oibundles2.com"
	F.WriteLine "0.0.0.0 cdn.insta.playbryte.com"
	F.WriteLine "0.0.0.0 cdn.llogetfastcach.us"
	F.WriteLine "0.0.0.0 cdn.montiera.com"
	F.WriteLine "0.0.0.0 cdn.msdwnld.com"
	F.WriteLine "0.0.0.0 cdn.mypcbackup.com"
	F.WriteLine "0.0.0.0 cdn.ppdownload.com"
	F.WriteLine "0.0.0.0 cdn.riceateastcach.us"
	F.WriteLine "0.0.0.0 cdn.shyapotato.us"
	F.WriteLine "0.0.0.0 cdn.solimba.com"
	F.WriteLine "0.0.0.0 cdn.tuto4pc.com"
	F.WriteLine "0.0.0.0 cdn.appround.biz"
	F.WriteLine "0.0.0.0 cdn.bigspeedpro.com"
	F.WriteLine "0.0.0.0 cdn.bispd.com"
	F.WriteLine "0.0.0.0 cdn.bisrv.com"
	F.WriteLine "0.0.0.0 cdn.cdndp.com"
	F.WriteLine "0.0.0.0 cdn.download.sweetpacks.com"
	F.WriteLine "0.0.0.0 cdn.dpdownload.com"
	F.WriteLine "0.0.0.0 cdn.visualbee.net"
F.Close

wait(5)
WScript.Quit

Function printf(txt)
	WScript.StdOut.WriteLine txt
End Function

Function printl(txt)
	WScript.StdOut.Write txt
End Function

Function scanf()
	scanf = LCase(WScript.StdIn.ReadLine)
End Function

Function Wait(n)
	WScript.Sleep Int(n * 1000)
End Function

Function ForceConsole()
	If InStr(LCase(WScript.FullName), "cscript.exe") = 0 Then
		oWSH.Run "cscript //NoLogo " & Chr(34) & WScript.ScriptFullName & Chr(34)
		WScript.Quit
	End If
End Function

Function showBanner()
	printf " _____ _ _           _____         _    _____         _     _   "
	printf "|  _  |_| |_ ___ ___|     |_ _ _ _| |  |   __|___ ___|_|___| |_ "
	printf "|     | | '_| . |   |   --| | | | . |  |__   |  _|  _| | . |  _|"
	printf "|__|__|_|_,_|___|_|_|_____|_____|___|  |_____|___|_| |_|  _|_|  "
	printf "                                                       |_|     v" & currentVersion
End Function

Function checkW10()
	If getNTversion < 10 Then
		printf " ERROR: Necesitas ejecutar este script bajo Windows 10"
		printf ""
		printf " Press <enter> to quit"
		scanf
		WScript.Quit
	End If
End Function

Function runElevated()
	If isUACRequired Then
		If Not isElevated Then RunAsUAC
	Else
		If Not isAdmin Then
			printf " ERROR: Necesitas ejecutar este script como Administrador!"
			printf ""
			printf " Press <enter> to quit"
			scanf
			WScript.Quit
		End If
	End If
End Function
 
Function isUACRequired()
	r = isUAC()
	If r Then
		intUAC = oWSH.RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA")
		r = 1 = intUAC
	End If
	isUACRequired = r
End Function

Function isElevated()
	isElevated = CheckCredential("S-1-16-12288")
End Function

Function isAdmin()
	isAdmin = CheckCredential("S-1-5-32-544")
End Function
 
Function CheckCredential(p)
	Set oWhoAmI = oWSH.Exec("whoami /groups")
	Set WhoAmIO = oWhoAmI.StdOut
	WhoAmIO = WhoAmIO.ReadAll
	CheckCredential = InStr(WhoAmIO, p) > 0
End Function
 
Function RunAsUAC()
	If isUAC Then
		printf ""
		printf " El script necesita ejecutarse con permisos elevados..."
		printf " acepta el siguiente mensaje:"
		Wait(1)
		oAPP.ShellExecute "cscript", "//NoLogo " & Chr(34) & WScript.ScriptFullName & Chr(34), "", "runas", 1
		WScript.Quit
	End If
End Function
 
Function isUAC()
	Set cWin = oWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem")
	r = False
	For Each OS In cWin
		If Split(OS.Version,".")(0) > 5 Then
			r = True
		Else
			r = False
		End If
	Next
	isUAC = r
End Function

Function getNTversion()
	Set cWin = oWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem")
	For Each OS In cWin
		getNTversion = Split(OS.Version,".")(0)
	Next
End Function

Function cls()
	For i = 1 To 50
		printf ""
	Next
End Function

Function showMenu(n)
	cls
	Call showBanner
	Wait(n)
	printf " Selecciona una opcion:"
	printf ""
	printf "   1 = Instalar/Desinstalar varios Tweaks para Windows 10"
	printf ""
	printf "   2 = Deshabilitar Control de Cuentas de Usuario (UAC)"
	printf "   3 = Ejecutar limpiador de Windows. Libera espacio y borrar Windows.old"
	printf "   4 = Habilitar/Deshabilitar inicio de sesion sin password"
	printf "   5 = Mostrar listado de combinacion de teclas utiles en Win10"
	printf "   6 = Instalar/Desinstalar caracteristicas de Windows"
	printf ""
	printf "   7 = Impedir que Microsoft recopile informacion de mi PC (Spyware & Telemetry)"
	printf "   8 = Desinstalar Metro Apps pre-instaladas en Windows 10"
	printf "   9 = Deshabilitar Windows Defender"
	printf "  10 = Deshabilitar OneDrive"
	printf ""
	printf "  11 = Optimizar y prolongar la vida de tu disco duro SSD"
	printf ""
	printf "  12 = Mostrar estado de la activacion de Windows 10"
	printf "  13 = Activar Windows 10; Ejecuta slmgr /ato 30 veces seguidas"
	printf ""
	printf "  99 = Restore Menu; Restaura la configuracion original"
	printf "   0 = Salir"
	printf ""
	printl " > "
	RP = scanf
	If Not isNumeric(RP) = True Then
		printf ""
		printf " ERROR: Opcion invalida, solo se permiten numero..."
		Call showMenu(2)
		Exit Function
	End If
	Select Case RP
		Case 1
			Call regTweaks()
		Case 2
			Call disableUAC()
		Case 3
			Call cleanSO()
		Case 4
			Call noPWD()
		Case 5
			Call showKeyboardTips()
		Case 6
			Call optionalFeatures()
		Case 7
			Call disableSpyware()
		Case 8
			Call cleanApps()
		Case 9
			Call disableDefender()
		Case 10
			Call disableOneDrive()
		Case 11
			Call powerSSD()
		Case 12
			Call showActivation()
		Case 13
			Call activate30()
		Case 99
			Call restoreMenu()
		Case 0
			printf ""
			printf " Gracias por utilizar mi script"
			printf " AikonCWD dice adios!! ;D"
			wait(2)
			WScript.Quit
		Case Else
		printf ""
		printf " INFO: Opcion invalida, ese numero no esta disponible"
		Call showMenu(2)
		Exit Function
	End Select
End Function

Function restoreMenu()
	cls
	printf " _____         _                  _____             "
	printf "| __  |___ ___| |_ ___ ___ ___   |     |___ ___ _ _ "
	printf "|    -| -_|_ -|  _| . |  _| -_|  | | | | -_|   | | |"
	printf "|__|__|___|___|_| |___|_| |___|  |_|_|_|___|_|_|___|"	
	printf ""
	printf " Selecciona una opcion:"
	printf ""
	printf "   1 = Habilitar Telemetria"
	printf "   2 = Habilitar servicios DiagTrack, RetailDemo y Dmwappush"
	printf "   3 = Habilitar tareas programadas que envian datos a Microsoft"
	printf "   4 = Restaurar hosts y acceso a servidores de publicidad de Microsoft"
	printf "   5 = Habilitar Windows Defender Antivirus"
	printf "   6 = Habilitar OneDrive"
	printf ""
	printf "   7 = Habilitar Shadow Copy (VSS) e Instantaneas de Volumen"
	printf "   8 = Habilitar Windows Search + Indexing Service"
	printf "   9 = Habilitar tarea programada del Defragmentador de discos"
	printf "  10 = Habilitar la hibernacion en el sistema"
	printf "  11 = Habilitar Prefetcher + Superfetch"
	printf "  12 = Deshabilitar el tema oscuro (Dark Theme)"
	printf ""
	printf "   0 = Salir; Regresar al menu principal"
	printf ""
	printl " > "
	RP = scanf
	If Not isNumeric(RP) = True Then
		printf ""
		printf " ERROR: Opcion invalida, solo se permiten numero..."
		Call restoreMenu()
		Exit Function
	End If
	Select Case RP
		Case 1
			On Error Resume Next
			printf ""
			printf " INFO: La opcion de Telemetria se ha restaurado a su valor original"
			oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\AllowTelemetry", 3, "REG_DWORD"
			oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection\AllowTelemetry", 3, "REG_DWORD"
			oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection\AllowTelemetry", 3, "REG_DWORD"
			oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..riencehost.appxmain_31bf3856ad364e35_10.0.10240.16384_none_0ab8ea80e84d4093\f!telemetry.js", 1, "REG_DWORD"
			oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0\f!dss-winrt-telemetry.js", 1, "REG_DWORD"
			oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0\f!proactive-telemetry.js", 1, "REG_DWORD"
			oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0\f!proactive-telemetry-event_8ac43a41e5030538", 1, "REG_DWORD"
			oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0\f!proactive-telemetry-inter_58073761d33f144b", 1, "REG_DWORD"
			oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\MRT\DontOfferThroughWUAU", 0, "REG_DWORD"
			oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat\AITEnable", 1, "REG_DWORD"
			oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows\CEIPEnable", 1, "REG_DWORD"
			oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat\DisableUAR", 0, "REG_DWORD"
			oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata\PreventDeviceMetadataFromNetwork", 0, "REG_DWORD"
		Case 2
			printf ""
			printf " INFO: Se han habilitado los servicios DiagTrack, RetailDemo y Dmwappush"
			oWSH.Run "sc config DiagTrack start=auto"
			oWSH.Run "sc config RetailDemo start=auto"
			oWSH.Run "sc config dmwappushservice start=auto"
			oWSH.Run "sc config WMPNetworkSvc start=auto"
			oWSH.Run "sc config diagnosticshub.standardcollector.service start=auto"
			oWSH.Run "sc start DiagTrack"
			oWSH.Run "sc start RetailDemo"
			oWSH.Run "sc start dmwappushservice"
			oWSH.Run "sc start WMPNetworkSvc"		
			oWSH.Run "sc start diagnosticshub.standardcollector.service"
		Case 3
			printf ""
			printf " INFO: Se han habilitado las tareas programadas que envian datos a Microsoft"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Application Experience\ProgramDataUpdater" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\AppID\SmartScreenSpecific" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\NetTrace\GatherNetworkInfo" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Error Reporting\QueueReporting" & chr(34) & " /ENABLE"			
		Case 4
			printf ""
			printf " INFO: El fichero hosts se ha restablecido correctamente"
			Set F = oFSO.CreateTextFile("C:\Windows\System32\drivers\etc\hosts", True)
				F.WriteLine "127.0.0.1	localhost"
				F.WriteLine "::1		localhost"
				F.WriteLine "127.0.0.1	local"
			F.Close
		Case 6
			printf ""
			printf " INFO: Se ha habilitado One Drive correctamente"
			oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive\DisableFileSyncNGSC", 0, "REG_DWORD"
			oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive\DisableFileSyncNGSC", 0, "REG_DWORD"
		Case 5
			printf ""
			printf " INFO: Se ha habilitado Windows Defender Antivirus correctamente"
			oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\DisableAntiSpyware", 0, "REG_DWORD"
			oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\DisableAntiSpyware", 0, "REG_DWORD"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" & chr(34) & " /ENABLE"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Defender\Windows Defender Verification" & chr(34) & " /ENABLE"
			oWSH.Run "sc config WdNisSvc start=auto"
			oWSH.Run "sc config WinDefend start=auto"	
			oWSH.Run "sc start WdNisSvc"
			oWSH.Run "sc start WinDefend"
		Case 7
			printf ""
			printf " INFO: Se ha habilitado el servicio de VSS (Shadow Copy)"
			oWSH.Run "sc config VSS start=auto"
			oWSH.Run "sc start VSS"
		Case 8
			printf ""
			printf " INFO: Se ha habilitado el servicio de Windows Search + Indexing Service"
			oWSH.Run "sc config WSearch start=auto"
			oWSH.Run "sc start WSearch"
		Case 9
			printf ""
			printf " INFO: Se ha habilitado la tarea programada del defragmentador de discos de Windows"
			oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Defrag\ScheduledDefrag" & chr(34) & " /ENABLE"
		Case 10
			printf ""
			printf " INFO: Hibernacion del sistema activada correctamente"
			oWSH.Run "powercfg -h on"
			oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power\HiberbootEnabled", 1, "REG_DWORD"
		Case 11
			printf ""
			printf " INFO. Se ha habilitado Prefetcher + Superfetch en el registro y en el servicio"
			oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnablePrefetcher", 1, "REG_DWORD"
			oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnableSuperfetch", 1, "REG_DWORD"
			oWSH.Run "sc config SysMain start=auto"
			oWSH.Run "sc start SysMain"
		Case 12
			printf ""
			printf " INFO: Se ha deshabilitado el tema oscuro (Dark Theme)"
			oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme", 1, "REG_DWORD"
			oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme", 1, "REG_DWORD"		
		Case 0
			MsgBox "Si has restaurado alguna opcion/configuracion, te recomiendo que reinicies el sistema ahora", vbInformation + vbOkOnly, "AikonCWD Script for Win10"
			Call showMenu(0)
		Case Else
			printf ""
			printf " INFO: Opcion invalida, ese numero no esta disponible"
			Call restoreMenu()
			Exit Function
	End Select
	Wait(2)
	Call restoreMenu()
End Function

Function disableUAC()
	printf ""
	printf " Ahora se ejecutara una ventana..."
	printf " Mueve la barra vertical hasta el nivel mas bajo"
	printf " Acepta los cambios y reinicia el ordenador"
	wait(2)
	printf ""
	printf " INFO: Executing UserAccountControlSettings.exe"
	oWSH.Run "UserAccountControlSettings.exe"
	Call showMenu(2)
End Function

Function cleanSO()
	printf ""
	printf " Ahora se ejecutara una ventana..."
	printf " Marca las opciones deseadas de limpieza"
	printf " Acepta los cambios y reinicia el ordenador"
	wait(2)
	printf ""
	printf " INFO: Executing cleanmgr.exe"
	oWSH.Run "cleanmgr.exe"
	Call showMenu(2)
End Function

Function noPWD()
	printf ""
	printf " Ahora se ejecutara una ventana..."
	printf " Desmarca la opcion: Los usuarios deben escribir su nombre y password para usar el equipo"
	printf " Acepta los cambios y reinicia el ordenador"
	wait(2)
	printf ""
	printf " INFO: Executing control userpasswords2"
	oWSH.Run "control userpasswords2"
	Call showMenu(2)
End Function

Function optionalFeatures()
	printf ""
	printf " Ahora se ejecutara una ventana..."
	printf " Marca/Desmarca las opciones deseadas"
	printf " Acepta los cambios y reinicia el ordenador"
	wait(2)
	printf ""
	printf " INFO: Executing optionalfeatures.exe"
	oWSH.Run "optionalfeatures.exe"
	Call showMenu(2)
End Function

Function showKeyboardTips()
	msg = msg & "WIN+A		Abre el centro de actividades" & vbcrlf
	msg = msg & "WIN+C		Activa el reconocimiento de voz de Cortana" & vbcrlf
	msg = msg & "WIN+D		Muestra el escritorio" & vbcrlf
	msg = msg & "WIN+E		Abre el explorador de Windows" & vbcrlf
	msg = msg & "WIN+G		Activa Game DVR para grabar la pantalla" & vbcrlf
	msg = msg & "WIN+H		Compartir en las apps Modern para Windows 10" & vbcrlf
	msg = msg & "WIN+I		Abre la configuracion del sistema" & vbcrlf
	msg = msg & "WIN+K		Inicia 'Conectar' para enviar datos a dispositivos" & vbcrlf
	msg = msg & "WIN+L		Bloquea el equipo" & vbcrlf
	msg = msg & "WIN+R		Ejecutar un comando" & vbcrlf
	msg = msg & "WIN+S		Activa Cortana" & vbcrlf
	msg = msg & "WIN+X		Abre el menu de opciones avanzadas" & vbcrlf
	msg = msg & "WIN+TAB		Abre la vista de tareas" & vbcrlf
	msg = msg & "WIN+Flechas	Pega una ventana a la pantalla (Windows Snap)" & vbcrlf
	msg = msg & "WIN+CTRL+D	Crea un nuevo escritorio virtual" & vbcrlf
	msg = msg & "WIN+CTRL+F4	Cierra un escritorio virtual" & vbcrlf
	msg = msg & "WIN+CTRL+Flechas	Cambia de escritorio virtual" & vbcrlf
	msg = msg & "WIN+SHIFT+Flechas	Mueve la ventana actual de un monitor a otro" & vbcrlf
	
	MsgBox msg, vbOkOnly, "AikonCWD Script: Atajos de teclado"
	Call showMenu(0)
End Function

Function disableSpyware()
	printf ""
	printf " Deshabilitando Telemetry usando el registro..."
	wait(1)
		On Error Resume Next
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\AllowTelemetry", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection\AllowTelemetry", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection\AllowTelemetry", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..riencehost.appxmain_31bf3856ad364e35_10.0.10240.16384_none_0ab8ea80e84d4093\f!telemetry.js", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0\f!dss-winrt-telemetry.js", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0\f!proactive-telemetry.js", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0\f!proactive-telemetry-event_8ac43a41e5030538", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0\f!proactive-telemetry-inter_58073761d33f144b", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\MRT\DontOfferThroughWUAU", 1, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat\AITEnable", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows\CEIPEnable", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat\DisableUAR", 1, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata\PreventDeviceMetadataFromNetwork", 1, "REG_DWORD"
	printf ""
	printf " INFO: Telemetry deshabilitado correctamente"
	
	pathLOG = oWSH.ExpandEnvironmentStrings("%ProgramData%") & "\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
	printf ""
	printf " Borrando DiagTrack Log..."
	wait(1)
		If oFSO.FileExists(pathLOG) Then oFSO.DeleteFile(pathLOG)
		oWSH.Run "cmd /C echo " & chr(34) & chr(34) & " > " & pathLOG
	printf ""
	printf " INFO: DiagTrack Log borrado correctamente"

	printf ""
	printf " Deshabilitando servicios de seguimiento..."
	wait(1)
		oWSH.Run "sc stop DiagTrack"
		oWSH.Run "sc stop RetailDemo"
		oWSH.Run "sc stop WMPNetworkSvc"
		oWSH.Run "sc stop dmwappushservice"
		oWSH.Run "sc stop diagnosticshub.standardcollector.service"
		oWSH.Run "sc config DiagTrack start=disabled"
		oWSH.Run "sc config RetailDemo start=disabled"
		oWSH.Run "sc config WMPNetworkSvc start=disabled"
		oWSH.Run "sc config dmwappushservice start=disabled"
		oWSH.Run "sc config diagnosticshub.standardcollector.service start=disabled"
	printf ""
	printf " INFO: Servicios de seguimiento deshabilitados"

	printf ""
	printf " Deshabilitando tareas programadas que envian datos a Microsoft..."	
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Application Experience\ProgramDataUpdater" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\AppID\SmartScreenSpecific" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\NetTrace\GatherNetworkInfo" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Error Reporting\QueueReporting" & chr(34) & " /DISABLE"
	printf ""
	printf " INFO: Tareas programadas de seguimiento deshabilitadas"

	printf ""
	printf " Deshabilitando acceso a los servidores de publicidad de Microsoft..."
	wait(1)
	Set F = oFSO.CreateTextFile(oWSH.ExpandEnvironmentStrings("%WinDir%") & "\System32\drivers\etc\hosts", True)
		F.WriteLine "127.0.0.1	localhost"
		F.WriteLine "::1		localhost"
		F.WriteLine "127.0.0.1	local"
		F.WriteLine "0.0.0.0 vortex.data.microsoft.com"
		F.WriteLine "0.0.0.0 vortex-win.data.microsoft.com"
		F.WriteLine "0.0.0.0 telecommand.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 telecommand.telemetry.microsoft.com.nsatc.net"
		F.WriteLine "0.0.0.0 oca.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 oca.telemetry.microsoft.com.nsatc.net"
		F.WriteLine "0.0.0.0 sqm.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 sqm.telemetry.microsoft.com.nsatc.net"
		F.WriteLine "0.0.0.0 watson.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 watson.telemetry.microsoft.com.nsatc.net"
		F.WriteLine "0.0.0.0 redir.metaservices.microsoft.com"
		F.WriteLine "0.0.0.0 choice.microsoft.com"
		F.WriteLine "0.0.0.0 choice.microsoft.com.nsatc.net"
		F.WriteLine "0.0.0.0 df.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 wes.df.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 reports.wes.df.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 services.wes.df.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 sqm.df.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 watson.ppe.telemetry.microsoft.com"
		F.WriteLine "0.0.0.0 telemetry.appex.bing.net"
		F.WriteLine "0.0.0.0 telemetry.urs.microsoft.com"
		F.WriteLine "0.0.0.0 telemetry.appex.bing.net:443"
		F.WriteLine "0.0.0.0 settings-sandbox.data.microsoft.com"
		F.WriteLine "0.0.0.0 vortex-sandbox.data.microsoft.com"
		F.WriteLine "0.0.0.0 survey.watson.microsoft.com"
		F.WriteLine "0.0.0.0 watson.live.com"
		F.WriteLine "0.0.0.0 watson.microsoft.com"
		F.WriteLine "0.0.0.0 statsfe2.ws.microsoft.com"
		F.WriteLine "0.0.0.0 corpext.msitadfs.glbdns2.microsoft.com"
		F.WriteLine "0.0.0.0 compatexchange.cloudapp.net"
		F.WriteLine "0.0.0.0 cs1.wpc.v0cdn.net"
		F.WriteLine "0.0.0.0 a-0001.a-msedge.net"
		F.WriteLine "0.0.0.0 statsfe2.update.microsoft.com.akadns.net"
		F.WriteLine "0.0.0.0 sls.update.microsoft.com.akadns.net"
		F.WriteLine "0.0.0.0 fe2.update.microsoft.com.akadns.net"
		F.WriteLine "0.0.0.0 diagnostics.support.microsoft.com"
		F.WriteLine "0.0.0.0 corp.sts.microsoft.com"
		F.WriteLine "0.0.0.0 statsfe1.ws.microsoft.com"
		F.WriteLine "0.0.0.0 pre.footprintpredict.com"
		F.WriteLine "0.0.0.0 i1.services.social.microsoft.com"
		F.WriteLine "0.0.0.0 i1.services.social.microsoft.com.nsatc.net"
		F.WriteLine "0.0.0.0 feedback.windows.com"
		F.WriteLine "0.0.0.0 feedback.microsoft-hohm.com"
		F.WriteLine "0.0.0.0 feedback.search.microsoft.com"
	F.Close
	printf ""
	printf " INFO: Fichero HOSTS escrito correctamente"
	Call showMenu(2)
End Function

Function disableOneDrive()
	printf ""
	printf " Deshabilitando OneDrive usando el registro..."
	wait(1)
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive\DisableFileSyncNGSC", 1, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive\DisableFileSyncNGSC", 1, "REG_DWORD"
	printf ""
	printf " INFO: OneDrive deshabilitado correctamente"
	Call showMenu(2)
End Function

Function disableDefender()
	printf ""
	printf " Deshabilitando Windows Defender usando el registro..."
	wait(1)
		oWSH.Run "sc stop WdNisSvc"
		oWSH.Run "sc stop WinDefend"
		oWSH.Run "sc config WdNisSvc start=disabled"
		oWSH.Run "sc config WinDefend start=disabled"	
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" & chr(34) & " /DISABLE"
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Windows Defender\Windows Defender Verification" & chr(34) & " /DISABLE"
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\DisableAntiSpyware", 1, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\DisableAntiSpyware", 1, "REG_DWORD"
	printf ""
	printf " INFO: Windows Defender deshabilitado correctamente"
	printf " WARNING: Si no tienes antivirus, te recomiendo 360 Total Security: www.360totalsecurity.com"
	wait(1)
	Call showMenu(2)
End Function

Function showActivation()
	printf ""
	printf " En unos segundos aparecera el estado de tu activacion..."
	wait(1)
		oWSH.Run "slmgr.vbs /dlv"
		oWSH.Run "slmgr.vbs /xpr"
	printf ""
	printf " INFO: Script slmgr ejecutado correctamente"
	Call showMenu(2)
End Function

Function activate30()
	printf ""
	printf " Esta funcion sirve para forzar la activacion de Windows 10"
	printf " solo se debe utilizar si tienes problemas para validar la licencia"
	printf ""
	printl " El proceso demora varios minutos. Deseas continuar? (s/n) "
	
	If scanf <> "s" Then
		printf ""
		printf " INFO: Proceso cancelado por el usuario"
		wait(1)
		Call showMenu(2)
		Exit Function
	End If
	
	printf " Se va a ejecutar slmgr /ato 30 veces, sea paciente..."
	wait(1)
		For i = 1 To 30
			printf "  > (" & i & ") Ejecutando slmgr.vbs /ato"
			oWSH.Run "slmgr.vbs /ato"
		Next
	printf ""
	printf " INFO: Script slmgr ejecutado correctamente"
	printf " INFO: El resultado tarda unos segundos en aparecer, espere..."
	wait(1)
	Call showMenu(2)
End Function

Function cleanApps()
	printf ""
	printf " Este script va a desinstalar el siguiente listado de Apps:"
	printf ""
	printf "  > Bing"
	printf "  > Zune"
	printf "  > Skype"
	printf "  > XboxApp"
	printf "  > OneNote"
	printf "  > 3DBuilder"
	printf "  > Getstarted"
	printf "  > Windows Maps"
	printf "  > Windows Phone"
	printf "  > Windows Camera"
	printf "  > Windows Alarms"
	printf "  > Windows Sound Recorder"
	printf "  > Windows Communications Apps"
	printf "  > Microsoft People"
	printf "  > Microsoft Office Hub"
	printf "  > Microsoft Solitaire Collection"
	printf ""
	printl " La opcion NO es reversible. Deseas continuar? (s/n) "
	
	If scanf = "s" Then
		oWSH.Run "powershell get-appxpackage -Name *Bing* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *Zune* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *XboxApp* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *OneNote* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *SkypeApp* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *3DBuilder* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *Getstarted* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *Microsoft.People* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *MicrosoftOfficeHub* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *MicrosoftSolitaireCollection* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *WindowsCamera* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *WindowsAlarms* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *WindowsMaps* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *WindowsPhone* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *WindowsSoundRecorder* | Remove-AppxPackage", 1, True
		oWSH.Run "powershell get-appxpackage -Name *windowscommunicationsapps* | Remove-AppxPackage", 1, True
		printf ""
		printf " INFO: Las Apps se han desinstalado correctamente..."
	Else
		printf ""
		printf " INFO: Operacion cancelada por el usuario"
	End If
	wait(1)
	Call showMenu(2)
End Function

Function powerSSD()
	printf ""
	printf " Este script va a modificar las siguientes configuraciones:"
	printf ""
	printf "  > Habilitar TRIM"
	printf "  > Deshabilitar VSS (Shadow Copy)"
	printf "  > Deshabilitar Windows Search + Indexing Service"
	printf "  > Deshabilitar defragmentador de discos"
	printf "  > Deshabilitar hibernacion del sistema"
	printf "  > Deshabilitar Prefetcher + Superfetch"
	printf "  > Deshabilitar ClearPageFileAtShutdown + LargeSystemCache"
	printf ""
	printl " Deseas continuar? (s/n) "
	
	If scanf = "s" Then
		printf ""
		oWSH.Run "fsutil behavior set disabledeletenotify 0"
		printf " # TRIM habilitado"
		wait(1)
		oWSH.Run "vssadmin Delete Shadows /All /Quiet"
		oWSH.Run "sc stop VSS"
		oWSH.Run "sc config VSS start=disabled"
		printf " # Shadow Copy eliminada y deshabilitada"
		wait(1)
		oWSH.Run "sc stop WSearch"
		oWSH.Run "sc config WSearch start=disabled"
		printf " # Windows Search + Indexing Service deshabilitados"
		wait(1)
		oWSH.Run "schtasks /change /TN " & chr(34) & "\Microsoft\Windows\Defrag\ScheduledDefrag" & chr(34) & " /DISABLE"
		printf " # Defragmentador de disco deshabilitado"
		wait(1)
		oWSH.Run "powercfg -h off"
		oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power\HiberbootEnabled", 0, "REG_DWORD"
		printf " # Hibernacion deshabilitada"
		wait(1)
		oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnablePrefetcher", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters\EnableSuperfetch", 0, "REG_DWORD"
		oWSH.Run "sc stop SysMain"
		oWSH.Run "sc config SysMain start=disabled"
		printf " # Prefetcher + Superfetch deshabilitados"
		wait(1)
		oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\ClearPageFileAtShutdown", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\LargeSystemCache", 0, "REG_DWORD"
		printf " # ClearPageFileAtShutdown + LargeSystemCache deshabilitados"
		wait(1)
		printf ""
		printf " INFO: Felicidades, acabas de prolongar la vida y el rendimiento de tu SSD"	
	Else
		printf ""
		printf " INFO: Operacion cancelada por el usuario"
	End If
	wait(1)
	Call showMenu(2)
End Function

Function regTweaks()
	On Error Resume Next
	printf ""
	printl " # Deshabilitar 'Acceso Rapido' como opcion por defecto en Explorer? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\LaunchTo", 1, "REG_DWORD"
	Else
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\LaunchTo", 2, "REG_DWORD"
	End If

	printl " # Crear icono 'Modo Dios' en el Escritorio? (s/n) "
	If scanf = "s" Then
		godFolder = oWSH.SpecialFolders("Desktop") & "\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
		If oFSO.FolderExists(godFolder) = False Then oFSO.CreateFolder(godFolder)
	Else
		godFolder = oWSH.SpecialFolders("Desktop") & "\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
		If oFSO.FolderExists(godFolder) = True Then oFSO.DeleteFolder(godFolder)	
	End If
	
	printl " # Habilitar el tema oscuro de Windows 'Dark Theme'? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme", 0, "REG_DWORD"
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme", 0, "REG_DWORD"
	Else
		oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme", 1, "REG_DWORD"
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme", 1, "REG_DWORD"		
	End If
	
	printl " # Mostrar icono 'Mi PC' en el Escritorio? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel\{20D04FE0-3AEA-1069-A2D8-08002B30309D}", 0, "REG_DWORD"
	Else
		oWSH.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel\{20D04FE0-3AEA-1069-A2D8-08002B30309D}", 1, "REG_DWORD"
	End If

	printl " # Mostrar siempre la extesion para archivos conocidos? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\HideFileExt", 0, "REG_DWORD"
	Else
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\HideFileExt", 1, "REG_DWORD"
	End If
	
	printl " # Deshabilitar 'Lock Screen'? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization\NoLockScreen", 1, "REG_DWORD"
	Else
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization\NoLockScreen", 0, "REG_DWORD"
	End If
	
	printl " # Forzar 'Vista Clasica' en el Panel de Control? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ForceClassicControlPanel", 1, "REG_DWORD"
	Else
		oWSH.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ForceClassicControlPanel", 0, "REG_DWORD"
	End If

	printl " # Deshabilitar 'Windows Update Sharing'? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config\DownloadMode", 0, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config\DODownloadMode", 0, "REG_DWORD"
	Else
		oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config\DownloadMode", 3, "REG_DWORD"
		oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config\DODownloadMode", 3, "REG_DWORD"
	End If
	
	printl " # Deshabilitar 'Windows Auto Update'? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\AUOptions", 2, "REG_DWORD"
	Else
		oWSH.RegDelete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\AUOptions"
	End If
	
	printl " # Deshabilitar Cortana + Bing + Barra busqueda? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search\AllowCortana", 0, "REG_DWORD"
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\CortanaEnabled", 0, "REG_DWORD"
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\SearchboxTaskbarMode", 0, "REG_DWORD"
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\BingSearchEnabled", 0, "REG_DWORD"
	Else
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search\AllowCortana", 1, "REG_DWORD"
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\CortanaEnabled", 1, "REG_DWORD"
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\SearchboxTaskbarMode", 1, "REG_DWORD"
		oWSH.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\BingSearchEnabled", 1, "REG_DWORD"
	End If

	printl " # Deshabilitar Reporte de Errores de Windows? (s/n) "
	If scanf = "s" Then
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Disabled", 1, "REG_DWORD"
	Else
		oWSH.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Disabled", 0, "REG_DWORD"
	End If
	
	printf ""
	printf " Todos los tweaks se han aplicado correctamente"
	showMenu(2)
End Function
