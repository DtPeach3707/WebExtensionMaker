#!/bin/bash

# Setting up an extension template from an empty folder
# So put this command then do mkdir extDir, cd extDir, then web-ext-init
# extDir is just the name of your extension directory

function web-ext-init()  
{
    echo "Extension name:"
    read extName
    echo "Manifest Version:"
    read maniVersion
    while [ $maniVersion != "2" ] && [ $maniVersion != "3" ] ; 
    do
        echo "This manifest version is not supported or does not exist"
        echo "Valid manifest versions include '2' and '3'"
        echo "Manifest Version:"
        read maniVersion
    done
    echo "Description:"
    read description
    echo "Version:"
    read version 
    echo "Include popup (y/n):"
    read popup
    while [ $popup != "y" ] && [ $popup != "n" ] ;
    do
        echo "Not a valid response. Response must be 'y' or 'n'"
        echo "Include popup (y/n):"
        read popup
    done
    echo "Include options (y/n):"
    read options
    while [ $options != "y" ] && [ $options != "n" ] ; 
    do
        echo "Not a valid response. Response must be 'y' or 'n'"
        echo "Include options (y/n):"
        read options
    done
    touch manifest.json
    echo "{" >| manifest.json
    printf '    "manifest_version": %s,\n' $maniVersion >> manifest.json
    echo '    "name": '  "\"$extName\"," >> manifest.json
    echo '    "description": '  "\"$description\"," >> manifest.json
    printf '    "version": "%s",\n' $version >> manifest.json
    if [ $maniVersion -eq 2 ] ; then
        echo '    "background":' >> manifest.json
        echo "    {" >> manifest.json
        echo '        "scripts": ["background.js"]' >> manifest.json
        echo "    }" >> manifest.json
    else
        echo '    "background":' >> manifest.json
        echo "    {" >> manifest.json
        echo '        "service_worker": ["background.js"]' >> manifest.json
    fi
    if [ $popup == "y" ] || [ $options == "y" ] ; then
        echo "    }," >> manifest.json
    else
        echo "    }" >> manifest.json
    fi
    touch background.js 
    if [ $popup == "y" ] ; then
        mkdir popup
        touch popup/popup.html
        echo "<!DOCTYPE html>" > popup/popup.html
        echo "<html>" >> popup/popup.html
        echo "   <head>" >> popup/popup.html
        echo '      <link rel="stylesheet" href="popup.css">' >> popup/popup.html
        echo "   </head>" >> popup/popup.html
        echo "   <body>" >> popup/popup.html
        echo '      <script src="popup.js"></script>' >> popup/popup.html
        echo "   </body>" >> popup/popup.html
        echo "</html>" >> popup/popup.html
        touch popup/popup.css
        touch popup/popup.js
        if [ $maniVersion -eq 2 ] ; then
            echo '    "browser_action": ' >> manifest.json
        else
            echo '    "action": ' >> manifest.json
        fi
        echo "    {" >> manifest.json
        echo '          "default_popup": "popup/popup.html"' >> manifest.json
        if [ $options == "y" ] ; then
            echo "    }," >> manifest.json
        else
            echo "    }" >> manifest.json
        fi
    fi
    if [ $options == "y" ] ; then
        mkdir options
        touch options/options.html
        echo "<!DOCTYPE html>" > options/options.html
        echo "<html>" >> options/options.html
        echo "   <head>" >> options/options.html
        echo '      <link rel="stylesheet" href="options.css">' >> options/options.html
        echo "   </head>" >> options/options.html
        echo "   <body>" >> options/options.html
        echo '      <script src="options.js"></script>' >> options/options.html
        echo "   </body>" >> options/options.html
        echo "</html>" >> options/options.html
        touch options/options.css
        touch options/options.js
        if [ $maniVersion -eq 3 ] ; then
            echo '    "options_page": "options/options.html"' >> manifest.json
        else
            echo '    "options_ui":' >> manifest.json 
            echo "    {" >> manifest.json
            echo '        "page": "options/options.html",' >> manifest.json
            echo '        "browser_style": true' >> manifest.json
            echo '    }' >> manifest.json
        fi
    fi
    echo "}" >> manifest.json
}
