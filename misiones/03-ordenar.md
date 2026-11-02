# Misión 3 · Ordenar

`mision/proyecto/descargas` tiene 27 archivos mezclados. Ordénalos y te dan el fragmento 3.

## PISO

```bash
cd mision/proyecto/descargas
mkdir imagenes documentos datos
ls *.jpg                          # mira antes de mover
mv *.jpg *.png imagenes/
mv *.pdf *.txt documentos/
mv *.csv *.json datos/
ls -l ../.secretos                      # permisos: caja_fuerte.txt no tiene ninguno (Git Bash: verás -r--r--r--)
cat ../.secretos/caja_fuerte.txt        # Permission denied (en Git Bash no falla: Windows no tiene permisos UNIX)
chmod +r ../.secretos/caja_fuerte.txt   # dale lectura
cat ../.secretos/caja_fuerte.txt
cd ../../..                             # vuelve a la carpeta del repo
```

Comprueba: `bash comprobar.sh orden` te da el fragmento → `bash comprobar.sh FRAGMENTO`

## TECHO

- Copia de seguridad de `mision/proyecto/datos` (la de arriba, no la de descargas) en `mision/proyecto/datos_backup` con un solo comando (`cp -r`).
- Renombra las fotos de `imagenes/` a `vacaciones_01.jpg`, `_02`... con un `for` de una línea (pista: `printf "%02d"`).
- `bash comprobar.sh techo 3`

Siguiente: [Misión 4](04-ejecutar.md)
