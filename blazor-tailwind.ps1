$projectname = $args[0]
$ishostedparam = $args[1]
$newdirpath = (Get-Location).Path

if (!$args) { Write-Host "Usage: main.ps1 `"PROJECT_NAME`" `"IS_HOSTED? [0/1]`"" -ForegroundColor Yellow }

Set-Location $newdirpath

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

$command = ""

try {
    if ($ishostedparam -eq "0") {
        $command = ""
        & dotnet new blazorwasm $command --name $projectname
    
        Set-Location $projectname

        & npx tailwindcss init
    
        $tailwindconfig = "module.exports = {content: [`"**/*.razor", "**/*.cshtml", "**/*.html`"], theme: {extend: {},}, plugins: [require('tailwind-scrollbar'),],}"
	
    
        $tailwindconfig > "./tailwind.config.js"
    
        Write-Host "tailwind.config.js is written succesfully" -ForegroundColor green
    
        [void](New-Item -Path . -Name "Styles" -ItemType "directory")
    
        [void](New-Item -Path "./Styles/" -Name "app.css" -ItemType "file")
    
        $appcss = "@tailwind base;
        @tailwind components;
        @tailwind utilities;"
    
        $appcss > "./Styles/app.css"
    
        Write-Host "Styles/app.css is written succesfully" -ForegroundColor green
    
        $indexhtml = "<!DOCTYPE html>
        <html lang=`"en`">
    
        <head>
            <meta charset=`"utf-8`" />
            <meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no`" />
            <title>MyBlazorApp</title>
            <base href=`"/`" />
            <link href=`"app.css`" rel=`"stylesheet`" />
        </head>
    
        <body>
            <div id=`"app`">Loading...</div>
            <script src=`"_framework/blazor.webassembly.js`"></script>
        </body>
    
        </html>
        "
    
        $indexhtml > "./wwwroot/index.html"
    
        Write-Host "wwwroot/index.html is written succesfully" -ForegroundColor green
    
        Remove-Item "./Shared/NavMenu.razor"
        Remove-Item "./Shared/NavMenu.razor.css"
        Remove-Item "./Shared/SurveyPrompt.razor"
    
        $mainlayout = "@inherits LayoutComponentBase
    
        <div class=`"page`">
            <main>
                <article class=`"`">
                    @Body
                </article>
            </main>
        </div>
        "
    
        $mainlayout > "./Shared/MainLayout.razor"
    
        Remove-Item "./Pages/Counter.razor"
        Remove-Item "./Pages/FetchData.razor"
    
        Write-Host "Bloat files removed successfully" -ForegroundColor green
    
        Set-Location "./wwwroot"
    
        $indexrazor = "@page `"/`"
    
        <PageTitle>Hello, World!</PageTitle>
        
        <div class=`"flex justify-center items-center h-[100vh] w-[100vw]`">
            <h1>
                Hello, World!
            </h1>
        </div>
        "
    
        $indexrazor > "../Pages/Index.razor"
    
        Remove-Item './css' -Recurse -Force
        Remove-Item './sample-data' -Recurse -Force
    }
    elseif ($ishostedparam -eq "1") {
        $command = "--hosted"
        & dotnet new blazorwasm $command --name $projectname
    
        Set-Location $projectname
        
        Set-Location "./Client"
		    
        & npx tailwindcss init
    
        $tailwindconfig = "module.exports = {
            content: [`"**/*.razor", "**/*.cshtml", "**/*.html`"],
            theme: {
            extend: {},
            },
            plugins: [],
        }"
    
        $tailwindconfig > "./tailwind.config.js"
    
        Write-Host "tailwind.config.js is written succesfully" -ForegroundColor green
    
        [void](New-Item -Path . -Name "Styles" -ItemType "directory")
    
        [void](New-Item -Path "./Styles/" -Name "app.css" -ItemType "file")
    
        $appcss = "@tailwind base;
        @tailwind components;
        @tailwind utilities;"
    
        $appcss > "./Styles/app.css"
    
        Write-Host "Styles/app.css is written succesfully" -ForegroundColor green
    
        $indexhtml = "<!DOCTYPE html>
        <html lang=`"en`">
    
        <head>
            <meta charset=`"utf-8`" />
            <meta name=`"viewport`" content=`"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no`" />
            <title>MyBlazorApp</title>
            <base href=`"/`" />
            <link href=`"app.css`" rel=`"stylesheet`" />
        </head>
    
        <body>
            <div id=`"app`">Loading...</div>
            <script src=`"_framework/blazor.webassembly.js`"></script>
        </body>
    
        </html>
        "
   		  $indexhtml > "./wwwroot/index.html"
        Remove-Item "./Shared/NavMenu.razor"
        Remove-Item "./Shared/NavMenu.razor.css"
        Remove-Item "./Shared/SurveyPrompt.razor"
    
        $mainlayout = "@inherits LayoutComponentBase
    
        <div class=`"page`">
            <main>
                <article class=`"`">
                    @Body
                </article>
            </main>
        </div>
        "
    
        $mainlayout > "./Shared/MainLayout.razor"
    
        Remove-Item "./Pages/Counter.razor"
        Remove-Item "./Pages/FetchData.razor"
    
        Set-Location "./wwwroot"
    
        $indexrazor = "@page `"/`"
    
        <PageTitle>Hello, World!</PageTitle>
        
        <div class=`"flex justify-center items-center h-[100vh] w-[100vw]`">
            <h1>
                Hello, World!
            </h1>
        </div>
        "
    
        $indexrazor > "../Pages/Index.razor"
    
        Remove-Item './css' -Recurse
        
    }
    else {
        Write-Host "Usage: main.ps1 `"PATH_TO_NEW_DIRECTORY`" `"PROJECT_NAME`" `"IS_HOSTED? [0/1]`""  -ForegroundColor Yellow
    }
}
catch {
    Write-Host "A wild error has appeared" -ForegroundColor Red
}

Write-Host "Script executed successfully!`nTailwind watch command: npx tailwindcss -i ./Styles/app.css -o ./wwwroot/app.css --watch`nDotnet watch command: dotnet watch run"
