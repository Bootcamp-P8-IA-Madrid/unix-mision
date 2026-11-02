# Misión 1 · Moverse

El fragmento 1 está en la carpeta más profunda de `mision/proyecto/datos`. Y está **oculta** (empieza por `.`).

## PISO

```bash
cd mision
pwd                              # ¿dónde estoy?
ls                               # ¿qué hay?
ls -la                           # lo mismo, con ocultos y permisos
ls proyecto/datos                # mira dentro sin entrar; ve alargando la ruta (Tab autocompleta)
cd proyecto/datos/raw/2023/backup
ls -la                           # ahí está la carpeta oculta
cat .olvidado/fragmento1.txt
cd -                             # vuelve a mision
cd ..                            # y a la carpeta del repo
```

Comprueba: `bash comprobar.sh FRAGMENTO`

## TECHO

- Desde `mision`, lista la carpeta oculta con una sola ruta relativa.
- Archivo más grande de `proyecto` sin abrir ninguno: `du -ah proyecto | sort -rh | head`
- ¿Cuántos archivos (no carpetas, ocultos incluidos) hay en `proyecto`? `find` + `wc -l` → `bash comprobar.sh techo 1 NUMERO`

Siguiente: [Misión 2](02-buscar.md)
