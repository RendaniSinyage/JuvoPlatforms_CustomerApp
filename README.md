#run the following code in this directory to get updated files
#.\scripts\create_update_zip.ps1
#alternatively you can run this command
#PowerShell -ExecutionPolicy Bypass -File .\create_update_zip.ps1

#To allow running local scripts, set the execution policy to RemoteSigned:
Set-ExecutionPolicy RemoteSigned

#once you get updated files run this script
#.\run_all_scripts.ps1

# to manually set hashes of comits you want to compare, run this command in the directory of your repository.
#git log --oneline
#otherwise it will use the latest two commits.
#the first one is the old commit and the second is the new commit
