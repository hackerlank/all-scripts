SET YYYYMMDD=%date:~0,4%%date:~5,2%%date:~8,2%
SET YYYYMMDDHHMISS=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
MD "D:\�ļ�����\%YYYYMMDDHHMISS%"
COPY /Y "D:\DBF\mktdt00-SH.txt" "D:\�ļ�����\%YYYYMMDDHHMISS%"
COPY /Y "D:\DBF\fjy%YYYYMMDD%.txt" "D:\�ļ�����\%YYYYMMDDHHMISS%"
COPY /Y "D:\DBF\SHOW2003-SH.DBF" "D:\�ļ�����\%YYYYMMDDHHMISS%"