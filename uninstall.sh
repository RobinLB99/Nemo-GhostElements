#!/bin/bash

# Script de desinstalación para Nemo-Hide

# Comprobar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root. Use sudo ./uninstall.sh"
  exit 1
fi

echo "Desinstalando Nemo-Hide..."

# Eliminar el script principal
if [ -f "/usr/share/nemo-python/extensions/nemo-hide.py" ]; then
    rm -v /usr/share/nemo-python/extensions/nemo-hide.py
fi

# Eliminar archivos de notificación
if [ -f "/usr/share/nemo-hide/nemo-hide-notification" ]; then
    rm -v /usr/share/nemo-hide/nemo-hide-notification
fi

if [ -f "/var/lib/update-notifier/user.d/nemo-hide-notification" ]; then
    rm -v /var/lib/update-notifier/user.d/nemo-hide-notification
fi

# Eliminar el directorio principal si está vacío
if [ -d "/usr/share/nemo-hide" ] && [ -z "$(ls -A /usr/share/nemo-hide)" ]; then
    rmdir -v /usr/share/nemo-hide
fi

# Eliminar archivos de traducción
for lang_dir in ./locale/*/ ; do
    lang=$(basename "$lang_dir")
    if [ -f "/usr/share/locale/$lang/LC_MESSAGES/Nemo-hide.mo" ]; then
        rm -v "/usr/share/locale/$lang/LC_MESSAGES/Nemo-hide.mo"
    fi
done

echo ""
echo "Desinstalación completada."
echo "Para aplicar los cambios, por favor ejecute el siguiente comando manualmente:"
echo "nemo -q"
echo ""
echo "O cierre sesión y vuelva a iniciarla para que los cambios surtan efecto."

echo "¡Listo! La extensión Nemo-Hide ha sido desinstalada correctamente." 