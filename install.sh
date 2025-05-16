#!/bin/bash

# Script de instalación para Nemo-Hide
# Este script instala el complemento Nemo-Hide sin necesidad de usar el sistema de paquetes Debian

# Comprobar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root. Use sudo ./install.sh"
  exit 1
fi

# Comprobar dependencias
echo "Comprobando dependencias..."
DEPS_OK=true

# Comprobar Nemo
if ! command -v nemo &> /dev/null; then
    echo "Error: Nemo no está instalado. Instálelo con: sudo apt-get install nemo"
    DEPS_OK=false
fi

# Comprobar Python 3
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 no está instalado. Instálelo con: sudo apt-get install python3"
    DEPS_OK=false
fi

# Comprobar xautomation (para el comando xte)
if ! command -v xte &> /dev/null; then
    echo "Error: xautomation no está instalado. Instálelo con: sudo apt-get install xautomation"
    DEPS_OK=false
fi

if [ "$DEPS_OK" = false ]; then
    echo "Por favor, instale las dependencias faltantes y vuelva a ejecutar este script."
    exit 1
fi

# Crear directorios de destino
echo "Creando directorios..."

# Directorio principal para la extensión
mkdir -p /usr/share/nemo-hide/

# Directorio para las extensiones de Python
mkdir -p /usr/share/nemo-python/extensions/

# Compilar traducciones si no existen los archivos .mo
if [ ! -d "locale" ] || [ -z "$(find locale -name '*.mo')" ]; then
    echo "Compilando traducciones..."
    ./compile_translations.sh
fi

# Copiar archivos
echo "Copiando archivos..."

# Copiar script principal
cp -v ./src/nemo-hide.py /usr/share/nemo-python/extensions/

# Copiar archivo de notificación
cp -v ./data/nemo-hide-notification /usr/share/nemo-hide/

# Copiar archivos de traducción
for lang_dir in ./locale/*/ ; do
    lang=$(basename "$lang_dir")
    mkdir -p "/usr/share/locale/$lang/LC_MESSAGES/"
    cp -v "$lang_dir/LC_MESSAGES/Nemo-hide.mo" "/usr/share/locale/$lang/LC_MESSAGES/"
done

# Configurar notificación si existe el directorio adecuado
if [ -d "/var/lib/update-notifier/user.d/" ]; then
    echo "Configurando notificación..."
    cp -v /usr/share/nemo-hide/nemo-hide-notification /var/lib/update-notifier/user.d/
    touch /var/lib/update-notifier/dpkg-run-stamp
fi

echo ""
echo "Instalación completada." 
echo "Para activar la extensión, por favor ejecute el siguiente comando manualmente:"
echo "nemo -q"
echo ""
echo "O cierre sesión y vuelva a iniciarla para que los cambios surtan efecto." 