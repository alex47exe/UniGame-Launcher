#RequireAdmin
#NoTrayIcon

$file_path = _file_path_ ; will be automatically replaced with correct file path
$file_only = StringTrimLeft(_file_path_, StringInStr(_file_path_, "\", 0, -1)) ; file name + extension
$path_only = StringTrimRight(_file_path_, StringLen($file_only)+1) ; folder containing the file

; RunWait(@ComSpec & ' /c ' & '"' & _file_path_ & '"', $path_only, @SW_HIDE)
RunWait(@ComSpec & ' /c ' & '"' & _file_path_ & '"', $path_only)
