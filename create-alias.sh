#!/bin/bash

function addbashaliases() {

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  cat >> ~/.bashrc << EOT
blazortailwind() 
{
    powershell -File "${SCRIPT_DIR}/dotnet-blazor-tailwind.ps1" $1 $2
}
EOT

}

addbashaliases

