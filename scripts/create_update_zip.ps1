# Check if manual.txt exists
if (Test-Path -Path "manual.txt") {
    # Copy content from manual.txt to gethashes.txt
    Get-Content -Path "manual.txt" | Out-File -FilePath "gethashes.txt"
} else {
    # Run git log and get the latest two commit hashes
    $hashes = git log --oneline | Select-Object -First 2 | ForEach-Object { $_.Split(' ')[0] }
    
    # Write the second latest commit hash to line one of gethashes.txt
    $hashes[1] | Out-File -FilePath "gethashes.txt"
    
    # Write the latest commit hash to line two of gethashes.txt
    $hashes[0] | Out-File -FilePath "gethashes.txt" -Append
}
# Delete existing updated_files.txt and updated_files.zip if they exist
Remove-Item -Path "updated_files.txt" -ErrorAction SilentlyContinue
Remove-Item -Path "updated_files.zip" -ErrorAction SilentlyContinue
# Read the content of gethashes.txt
$hashes = Get-Content -Path "gethashes.txt"

# Ensure we have exactly two hashes
if ($hashes.Count -ne 2) {
    Write-Error "gethashes.txt should contain exactly two hashes"
    exit 1
}

$oldHash = $hashes[0].Trim()
$newHash = $hashes[1].Trim()

Write-Host "Old hash: $oldHash"
Write-Host "New hash: $newHash"
# Set working directory to parent folder
$parentFolder = Split-Path -Parent $PSScriptRoot
Set-Location $parentFolder

$outputZip = "updated_files.zip"

# Function to determine the project type
function Get-ProjectType {
    if (Test-Path "pubspec.yaml") {
        $pubspecContent = Get-Content "pubspec.yaml" -Raw
        if ($pubspecContent -match "name:\s*venderfoodyman") { return "manager" }
        elseif ($pubspecContent -match "name:\s*riverpodtemp") { return "user" }
        elseif ($pubspecContent -match "name:\s*vender") { return "driver" }
        elseif ($pubspecContent -match "name:\s*admin_desktop") { return "pos" }
    }
    elseif (Test-Path ".env") {
        $envContent = Get-Content ".env" -Raw
        if ($envContent -match "APP_NAME=foodyman") { return "backend" }
        elseif ($envContent -match "NEXT_PUBLIC_WEBSITE_URL=https://foodyman.org") { return "webapp" }
        else { return "frontend" }
    }
    return "unknown"
}

# Generate the list of updated files using Git
# Note: Replace <old_commit> and <new_commit> with actual commit hashes
#git log --oneline
#git diff --name-only be48c36..3f7f603 > updated_files.txt
#git diff --name-only 25022024..28062024 > updated_files.txt
#git diff --name-only dbc1c64..8a593ba > updated_files.txt
# Perform git diff and save to file
$command = "git diff --name-only $oldHash..$newHash > updated_files.txt"

Write-Host "Executing command: $command"

# Execute the command
Invoke-Expression $command

# Check if the command was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Diff completed successfully. Results saved in updated_files.txt"
    
    # Display the contents of the file
    Write-Host "Contents of updated_files.txt:"
    Get-Content updated_files.txt
} else {
    Write-Host "Error occurred while running git diff. Exit code: $LASTEXITCODE"
}

# Get the list of updated files, excluding .freezed.dart and app_router.gr.dart files
$updatedFiles = Get-Content updated_files.txt | Where-Object { 
    $_ -notmatch '\.freezed\.dart$' -and 
    $_ -notmatch 'app_router\.gr\.dart$'
}

# Create a temporary directory to stage our files
$tempDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP "temp_zip_$(Get-Random)")

try {
    foreach ($file in $updatedFiles) {
        $destFile = Join-Path $tempDir $file
        
        # Create the directory structure if it doesn't exist
        $destDir = Split-Path $destFile
        if (!(Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        
        # Copy the file to the temp directory, preserving the relative path
        Copy-Item $file $destFile -Force
    }

    # Create README.md file
    $instructionsContent = @"
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
"@
    $instructionsContent | Set-Content (Join-Path $tempDir "README.md")

    # Create runscripts directory
    $runscriptsDir = Join-Path $tempDir "runscripts"
    New-Item -ItemType Directory -Path $runscriptsDir -Force | Out-Null

    # Create folderupdates.ps1 file
    $folderUpdatesScript = @"
# Determine project type
$projectType = Get-ProjectType

# Update folder structure based on project type
switch ($projectType) {
    "manager" {
        `$oldPath = "android\app\src\main\kotlin\org\foodyman\manager"
        `$newPath = "android\app\src\main\kotlin\app\juvo\vendor"
    }
    "user" {
        `$oldPath = "android\app\src\main\kotlin\com\example\reverpod"
        `$newPath = "android\app\src\main\kotlin\app\juvo\food"
    }
    "driver" {
        `$oldPath = "android\app\src\main\kotlin\org\foodyman\deliveryman"
        `$newPath = "android\app\src\main\kotlin\app\juvo\driver"
    }
    "pos" {
        `$oldPath = "android\app\src\main\kotlin\org\goshops\admin_desktop"
        `$newPath = "android\app\src\main\kotlin\app\juvo\pos"
    }
    default {
        Write-Host "No folder updates needed for this project type."
        return
    }
}

if (Test-Path `$oldPath) {
    # Create the new directory structure
    New-Item -ItemType Directory -Path (Split-Path `$newPath) -Force | Out-Null

    # Move the contents
    Move-Item -Path `$oldPath\* -Destination `$newPath -Force

    # Remove the old directory structure
    Remove-Item -Path (Split-Path `$oldPath) -Recurse -Force

    Write-Host "Folder structure updated successfully."
} else {
    Write-Host "Old folder structure not found. No changes made."
}
"@
    $folderUpdatesScript | Set-Content (Join-Path $runscriptsDir "folderupdates.ps1")

    # Create fileedits.ps1 file
    $fileEditsScript = @"
# Function to replace content in a file
function Replace-FileContent {
    param (
        [string]`$FilePath,
        [string]`$OldContent,
        [string]`$NewContent
    )

    if (Test-Path `$FilePath) {
        (Get-Content `$FilePath) | 
            ForEach-Object { `$_ -replace [regex]::Escape(`$OldContent), `$NewContent } | 
            Set-Content `$FilePath
        Write-Host "Updated `$FilePath"
    } else {
        Write-Host "File not found: `$FilePath"
    }
}

# Determine project type
$projectType = Get-ProjectType

# Project-specific replacements
switch ($projectType) {
    "manager" {
        Replace-FileContent -FilePath "android\app\src\main\kotlin\app\juvo\vendor\MainActivity.kt" -OldContent "package org.foodyman.manager" -NewContent "package app.juvo.vendor"
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'package="org.foodyman.manager">' -NewContent 'package="app.juvo.vendor">'
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'android:value="AIzaSyAIZAHqq0Gpw0yNcq6LgsQd9EAGpee5sMg"' -NewContent 'android:value="AIzaSyDJjLCq6HBCe7xae6l0D9DW1MWpE4900GU"'
        Replace-FileContent -FilePath "android\app\src\debug\AndroidManifest.xml" -OldContent "package org.foodyman.manager" -NewContent "package app.juvo.vendor"
        Replace-FileContent -FilePath "android\app\src\profile\AndroidManifest.xml" -OldContent "package org.foodyman.manager" -NewContent "package app.juvo.vendor"
        Replace-FileContent -FilePath "android\build.gradle" -OldContent 'applicationId "app.juvo.pos"' -NewContent 'applicationId "app.juvo.pos"'
    }
    "user" {
        Replace-FileContent -FilePath "android\app\src\main\kotlin\app\juvo\food\MainActivity.kt" -OldContent "package com.foodyman" -NewContent "package app.juvo.food"
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'package="com.foodyman">' -NewContent 'package="app.juvo.food">'
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'android:value="AIzaSyAIZAHqq0Gpw0yNcq6LgsQd9EAGpee5sMg"' -NewContent 'android:value="AIzaSyDJjLCq6HBCe7xae6l0D9DW1MWpE4900GU"'
        Replace-FileContent -FilePath "android\app\src\debug\AndroidManifest.xml" -OldContent "package com.foodyman" -NewContent "package app.juvo.food"
        Replace-FileContent -FilePath "android\app\src\profile\AndroidManifest.xml" -OldContent "package com.foodyman" -NewContent "package app.juvo.food"
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'android:label="Foodyman">' -NewContent 'android:label="Juvo">'
        Replace-FileContent -FilePath "android\build.gradle" -OldContent 'applicationId "com.foodyman"' -NewContent 'applicationId "app.juvo.food"'
    }
    "driver" {
        Replace-FileContent -FilePath "android\app\src\main\kotlin\app\juvo\driver\MainActivity.kt" -OldContent "package org.foodyman.deliveryman" -NewContent "package app.juvo.driver"
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'package="org.foodyman.deliveryman">' -NewContent 'package="app.juvo.driver">'
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'android:value="AIzaSyAIZAHqq0Gpw0yNcq6LgsQd9EAGpee5sMg"' -NewContent 'android:value="AIzaSyDJjLCq6HBCe7xae6l0D9DW1MWpE4900GU"'
        Replace-FileContent -FilePath "android\app\src\debug\AndroidManifest.xml" -OldContent "package org.foodyman.deliveryman" -NewContent "package app.juvo.driver"
        Replace-FileContent -FilePath "android\app\src\profile\AndroidManifest.xml" -OldContent "package org.foodyman.deliveryman" -NewContent "package app.juvo.driver"
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'android:label="Driver App">' -NewContent 'android:label="Driver">'
        Replace-FileContent -FilePath "android\build.gradle" -OldContent 'applicationId "org.foodyman.deliveryman"' -NewContent 'applicationId "app.juvo.driver"'
    }
    "pos" {
        Replace-FileContent -FilePath "android\app\src\main\kotlin\app\juvo\pos\MainActivity.kt" -OldContent "package org.foodyman.pos" -NewContent "package app.juvo.pos"
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'package="org.foodyman.pos">' -NewContent 'package="app.juvo.pos">'
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'android:value="AIzaSyAIZAHqq0Gpw0yNcq6LgsQd9EAGpee5sMg"' -NewContent 'android:value="AIzaSyDJjLCq6HBCe7xae6l0D9DW1MWpE4900GU"'
        Replace-FileContent -FilePath "android\app\src\debug\AndroidManifest.xml" -OldContent "package org.foodyman.pos" -NewContent "package app.juvo.pos"
        Replace-FileContent -FilePath "android\app\src\profile\AndroidManifest.xml" -OldContent "package org.foodyman.pos" -NewContent "package app.juvo.pos"
        Replace-FileContent -FilePath "android\app\src\main\AndroidManifest.xml" -OldContent 'android:label="Driver App">' -NewContent 'android:label="Driver">'
        Replace-FileContent -FilePath "android\build.gradle" -OldContent 'applicationId "org.foodyman.pos"' -NewContent 'applicationId "app.juvo.pos"'
    }
    "backend" {
        Replace-FileContent -FilePath ".env" -OldContent "APP_NAME=foodyman" -NewContent "APP_NAME=JuvoPlatforms"
        Replace-FileContent -FilePath ".env" -OldContent "APP_DEBUG=true" -NewContent "APP_DEBUG=false"
        Replace-FileContent -FilePath ".env" -OldContent "APP_URL=https://example.org/" -NewContent "APP_URL=https://api.juvo.app/"
        Replace-FileContent -FilePath ".env" -OldContent "DB_DATABASE=root" -NewContent "DB_DATABASE=admin_foodyman"
        Replace-FileContent -FilePath ".env" -OldContent "DB_USERNAME=root" -NewContent "DB_USERNAME=glover"
        Replace-FileContent -FilePath ".env" -OldContent "DB_PASSWORD=" -NewContent "DB_PASSWORD=Linkme78"
        Replace-FileContent -FilePath ".env" -OldContent "AWS_ACCESS_KEY_ID=" -NewContent "AWS_ACCESS_KEY_ID=AKIAQCB6Z3SDG5XWVVNE"
        Replace-FileContent -FilePath ".env" -OldContent "AWS_SECRET_ACCESS_KEY=" -NewContent "AWS_SECRET_ACCESS_KEY=B1/7cxFVg3hXC4o/XnWeesYIXm3A/FB+tQ/TRV6+"
        Replace-FileContent -FilePath ".env" -OldContent "AWS_DEFAULT_REGION=" -NewContent "AWS_DEFAULT_REGION=af-south-1"
        Replace-FileContent -FilePath ".env" -OldContent "AWS_BUCKET=" -NewContent "AWS_BUCKET=gosouth"
        Replace-FileContent -FilePath ".env" -OldContent "AWS_URL=" -NewContent "AWS_URL=s3://arn:aws:s3:af-south-1:004426685574:accesspoint/goaccess"
        Replace-FileContent -FilePath ".env" -OldContent "AWS_ENDPOINT=" -NewContent "AWS_ENDPOINT=https://gosouth.s3.af-south-1.amazonaws.com/"
        Replace-FileContent -FilePath ".env" -OldContent "AWS_USE_PATH_STYLE_ENDPOINT=" -NewContent "AWS_USE_PATH_STYLE_ENDPOINT=false"
        Replace-FileContent -FilePath ".env" -OldContent "IMG_HOST=https://example.org/storage/images/" -NewContent "IMG_HOST=https://d29qdaaunou30u.cloudfront.net/public/images/"
        Replace-FileContent -FilePath ".env" -OldContent "FRONT_URL=https://foodyman-web.vercel.app/" -NewContent "FRONT_URL=https://food.juvo.app/"
        Replace-FileContent -FilePath ".env" -OldContent "ADMIN_URL=https://admin-foodyman.vercel.app/" -NewContent "ADMIN_URL=https://admin.juvo.app/"
        Replace-FileContent -FilePath "config/database.php" -OldContent "'database' => env('DB_DATABASE', 'forge')," -NewContent "'database' => env('DB_DATABASE', 'admin_foodyman'),"
        Replace-FileContent -FilePath "config/database.php" -OldContent "'username' => env('DB_USERNAME', 'forge')," -NewContent "'username' => env('DB_USERNAME', 'glover'),"
        Replace-FileContent -FilePath "config/database.php" -OldContent "'purchase_id' => ''," -NewContent "'purchase_id' => '43679000',"
        Replace-FileContent -FilePath "config/database.php" -OldContent "'purchase_code' => ''," -NewContent "'purchase_code' => 'd8f94f83-1841-469c-8e3e-c868c671e9ed',"
        New-Item -ItemType File -Path "config/init.php" -Force
    }
    "frontend" {
        Replace-FileContent -FilePath ".env" -OldContent "PORT=4000" -NewContent "PORT=3000"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const PROJECT_NAME = 'Foodyman';" -NewContent "export const PROJECT_NAME = 'Juvo Platforms';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const BASE_URL = 'https://api.foodyman.org';" -NewContent "export const BASE_URL = 'https://api.juvo.app';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const WEBSITE_URL = 'https://foodyman.org';" -NewContent "export const WEBSITE_URL = 'https://food.juvo.app';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const MAP_API_KEY = 'AIzaSyAFx5wRV6TSua9AZAI73FmNWtd_0Cr0NbI';" -NewContent "export const MAP_API_KEY = 'AIzaSyDJjLCq6HBCe7xae6l0D9DW1MWpE4900GU';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const API_KEY = 'AIzaSyC-94TkEzZAFhV4XLq9q-EmWsx_z1_ZARo';" -NewContent "export const API_KEY = 'AIzaSyBtWjDrQdHtl628ZAQ1naWhPrsiidO18gg';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const AUTH_DOMAIN = 'foodyman-703bd.firebaseapp.com';" -NewContent "export const AUTH_DOMAIN = 'juvofood.firebaseapp.com';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const PROJECT_ID = 'foodyman-703bd';" -NewContent "export const PROJECT_ID = 'juvofood';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const STORAGE_BUCKET = 'foodyman-703bd.appspot.com';" -NewContent "export const STORAGE_BUCKET = 'juvofood.appspot.com';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const MESSAGING_SENDER_ID = '723986947199';" -NewContent "export const MESSAGING_SENDER_ID = '728921419683';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const APP_ID = '1:723986947199:web:5b3b23e1e9f97083f5334a';" -NewContent "export const APP_ID = '1:728921419683:web:81a97b726ba3fa120db416';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const MEASUREMENT_ID = 'G-09DRT9D4L0';" -NewContent "export const MEASUREMENT_ID = 'G-PKYDE4B9DS';"
        Replace-FileContent -FilePath "src/configs/app-global.js" -OldContent "export const VAPID_KEY = 'BHFv5NaxfCmJ9s2VPGdSG9TZ5gdux45UOpJW9fUDoFeqAsXv8XFZmzMI7vp84B6QAKiCD1eMy8E4M9f1RRPfRR0';" -NewContent "export const VAPID_KEY = 'BB51fvOx-TryBXR0r7K0O_EM4zmXMXsPyjc1jfQsWnjLpJzM2CLgGhpsoWELvZby7hH7oyt1sSGkkb_uvzqEJEM';"
    }
    "webapp" {
        Replace-FileContent -FilePath "styles/global.css" -OldContent "--primary: #83ea00;" -NewContent "--primary: #ffa100; /*changed*/"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_MAP_API_KEY=AIzaSyAFx5wRV6TSua9AZAI73FmNWtd_0Cr0NbI" -NewContent "NEXT_PUBLIC_MAP_API_KEY=AIzaSyDJjLCq6HBCe7xae6l0D9DW1MWpE4900GU"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_WEBSITE_URL=https://foodyman.org" -NewContent "NEXT_PUBLIC_WEBSITE_URL=https://food.juvo.app"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_BASE_URL=https://api.foodyman.org" -NewContent "NEXT_PUBLIC_BASE_URL=https://api.juvo.app"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_ADMIN_PANEL_URL=https://admin.foodyman.org" -NewContent "NEXT_PUBLIC_ADMIN_PANEL_URL=https://admin.juvo.app"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_API_HOSTNAME=api.foodyman.org" -NewContent "NEXT_PUBLIC_API_HOSTNAME=api.juvo.app"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_STORAGE_HOSTNAME=foodyman.s3.amazonaws.com" -NewContent "NEXT_PUBLIC_STORAGE_HOSTNAME=gosouth.s3.af-south-1.amazonaws.com"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_META_TITLE=Foodyman" -NewContent "NEXT_PUBLIC_META_TITLE=Juvo"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_META_DESCRIPTION=Food and Grocery Ordering and Delivery Marketplace" -NewContent "NEXT_PUBLIC_META_DESCRIPTION=Water and Food Ordering and Delivery Marketplace"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_META_IMAGE=https://foodyman.org/images/brand_logo.svg" -NewContent "NEXT_PUBLIC_META_IMAGE=https://food.juvo.app/images/brand_logo.svg"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_META_KEYWORDS=Restaurant" -NewContent "NEXT_PUBLIC_META_KEYWORDS=Restaurant"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_DEFAULT_LOCATION=41.29109522493603,69.22549522044032" -NewContent "NEXT_PUBLIC_DEFAULT_LOCATION=22.34058,30.01341"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_FIREBASE_API_KEY=AIzaSyC-94TkEzZAFhV4XLq9q-EmWsx_z1_ZARo" -NewContent "NEXT_PUBLIC_FIREBASE_API_KEY=AIzaSyBtWjDrQdHtl628ZAQ1naWhPrsiidO18gg"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=foodyman-703bd.firebaseapp.com" -NewContent "NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=juvofood.firebaseapp.com"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_FIREBASE_PROJECT_ID=foodyman-703bd" -NewContent "NEXT_PUBLIC_FIREBASE_PROJECT_ID=juvofood"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=foodyman-703bd.appspot.com" -NewContent "NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=juvofood.appspot.com"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=723986947199" -NewContent "NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=728921419683"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_FIREBASE_APP_ID=1:723986947199:web:5b3b23e1e9f97083f5334a" -NewContent "NEXT_PUBLIC_FIREBASE_APP_ID=1:728921419683:web:81a97b726ba3fa120db416"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID=G-09DRT9D4L0" -NewContent "NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID=G-PKYDE4B9DS"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_FIREBASE_VAPID_KEY=BHFv5NaxfCmJ9s2VPGdSG9TZ5gdux45UOpJW9fUDoFeqAsXv8XFZmzMI7vp84B6QAKiCD1eMy8E4M9f1RRPfRR0" -NewContent "NEXT_PUBLIC_FIREBASE_VAPID_KEY=BHFv5NaxfCmJ9s2VPGdSG9TZ5gdux45UOpJW9fUDoFeqAsXv8XFZmzMI7vp84B6QAKiCD1eMy8E4M9f1RRPfRR0"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_GOOGLE_MEASUREMENT_ID=G-Z7GMSWTN8P" -NewContent "NEXT_PUBLIC_GOOGLE_MEASUREMENT_ID=G-PKYDE4B9DS"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_DYNAMIC_LINK_DOMAIN=https://foodyman.page.link" -NewContent "NEXT_PUBLIC_DYNAMIC_LINK_DOMAIN=https://juvo.page.link"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_DYNAMIC_LINK_ANDROID_PACKAGE_NAME=com.foodyman" -NewContent "NEXT_PUBLIC_DYNAMIC_LINK_ANDROID_PACKAGE_NAME=app.juvo.food"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_DYNAMIC_LINK_IOS_BUNDLE_ID=com.foodyman.customer" -NewContent "NEXT_PUBLIC_DYNAMIC_LINK_IOS_BUNDLE_ID=com.app.juvo.food"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_LOGO=https://foodyman.org/images/brand_logo.svg" -NewContent "NEXT_PUBLIC_LOGO=https://food.juvo.app/images/brand_logo.svg"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_LOGO_DARK=https://foodyman.org/images/brand_logo_dark.svg" -NewContent "NEXT_PUBLIC_LOGO_DARK=https://food.juvo.app/images/brand_logo_dark.svg"
        Replace-FileContent -FilePath ".env" -OldContent "NEXT_PUBLIC_LOGO_ROUNDED=https://foodyman.org/images/brand_logo_rounded.svg" -NewContent "NEXT_PUBLIC_LOGO_ROUNDED=https://food.juvo.app/images/brand_logo_rounded.svg"
    }
    default {
        Write-Host "Unknown project type. No file edits performed."
    }
}
"@
    $fileEditsScript | Set-Content (Join-Path $runscriptsDir "fileedits.ps1")

    # Create run_all_scripts.ps1 file
    $runAllScriptsContent = @"
# Run all update scripts
Write-Host "Running folder updates..."
.\runscripts\folderupdates.ps1

Write-Host "`nRunning file edits..."
.\runscripts\fileedits.ps1

# Run all other scripts in /runscripts/
Get-ChildItem -Path ".\runscripts" -Filter "*.ps1" | 
    Where-Object { $_.Name -notin @("folderupdates.ps1", "fileedits.ps1") } | 
    ForEach-Object {
        Write-Host "`nRunning $($_.Name)..."
        & $_.FullName
    }

Write-Host "`nRunning Flutter build runner..."
flutter pub run build_runner build --delete-conflicting-outputs

Write-Host "`nAll updates completed."
"@
    $runAllScriptsContent | Set-Content (Join-Path $tempDir "run_all_scripts.ps1")

    # Create the zip file from the temp directory
    Compress-Archive -Path "$tempDir\*" -DestinationPath $outputZip -Force
    
    Write-Host "Zip file created successfully: $outputZip"
    # Assuming $updatedFiles is your collection of updated file paths

# Write the updated file paths to updated_files.txt
$updatedFiles | Out-File -FilePath "updated_files.txt"

# Count the number of updated files
$totalUpdatedFiles = $updatedFiles.Count

# Append the total count to updated_files.txt
Add-Content -Path "updated_files.txt" -Value "Total files included: $totalUpdatedFiles"

$androidGitignorePath = "android\.gitignore"
if (Test-Path $androidGitignorePath) {
    $content = Get-Content $androidGitignorePath
    $content = $content -replace "^key\.properties", "#key.properties"
    $content = $content -replace "^(\*\*/\*\.keystore)", "#$1"
    $content = $content -replace "^(\*\*/\*\.jks)", "#$1"
    Set-Content $androidGitignorePath $content
    Write-Host "Updated $androidGitignorePath"
}

    # Update .gitignore
    $gitignoreContent = Get-Content .gitignore -ErrorAction SilentlyContinue
    $newEntries = @("updated_files.txt", "updated_files.zip", "/scripts/gethashes.txt", "/scripts/manual.txt")
    $updatedGitignore = $gitignoreContent + $newEntries | Select-Object -Unique
    $updatedGitignore | Set-Content .gitignore
    Write-Host ".gitignore updated to exclude updated_files.txt and updated_files.zip"
}
finally {
    # Clean up: remove the temporary directory
    Remove-Item -Recurse -Force $tempDir
}