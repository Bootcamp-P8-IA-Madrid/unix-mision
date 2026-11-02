# Misión 2 · Buscar

El fragmento 2 está en una línea de `mision/proyecto/logs/app.log` (1.500 líneas). No lo leas entero: pregúntale.

## PISO

```bash
cd mision/proyecto
head -n 5 logs/app.log            # 5 primeras líneas
tail -n 5 logs/app.log            # 5 últimas
less logs/app.log                 # por páginas: /ERROR busca, n siguiente, q sale
grep fragmento logs/app.log       # la línea que buscas
grep ERROR logs/app.log | wc -l   # ¿cuántos errores? (tubería)
cd ../..                          # vuelve a la carpeta del repo
```

Comprueba: `bash comprobar.sh FRAGMENTO`

## TECHO

- ¿Qué módulo (auth, db, api, pagos, cache) falla más? Una línea: `grep` + `awk '{print $4}'` + `sort` + `uniq -c` + `sort -rn` → `bash comprobar.sh techo 2 MODULO`
- Solo los ERROR del día 2024-03-15 (dos `grep` encadenados).
- Busca `TODO` en todo el proyecto sin saber dónde está: `grep -rn TODO mision` (en Linux/macOS el aviso de *Permission denied* es normal: misión 3)

Siguiente: [Misión 3](03-ordenar.md)
