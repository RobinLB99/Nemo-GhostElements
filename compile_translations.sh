#!/bin/bash
# Script para compilar las traducciones

cd po

# Compilar cada archivo .po a .mo
for pofile in *.po; do
    lang=${pofile%.po}
    echo "Compiling translation for $lang..."
    mkdir -p ../locale/$lang/LC_MESSAGES
    msgfmt -o ../locale/$lang/LC_MESSAGES/Nemo-hide.mo $pofile
done

echo "Translations compiled successfully." 