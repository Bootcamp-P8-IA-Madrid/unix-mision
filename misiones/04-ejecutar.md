# Misión 4 · Ejecutar

El fragmento 4 lo da `mision/proyecto/herramientas/revelar.sh`... cuando consigas ejecutarlo y sepa quién eres.

## PISO

```bash
cd mision/proyecto
python3 herramientas/saluda.py hola mundo   # Windows: python (python3 suele no existir)
./herramientas/revelar.sh                   # Permission denied (en Git Bash se ejecuta y te pide identificarte)
chmod +x herramientas/revelar.sh            # (en Git Bash no falla; hazlo igual)
./herramientas/revelar.sh                   # te pide identificarte
export AGENTE=tu_nombre
./herramientas/revelar.sh
cd ../..                                    # vuelve a la carpeta del repo
```

Comprueba: `bash comprobar.sh FRAGMENTO` y luego la clave: `bash comprobar.sh F1-F2-F3-F4`

## TECHO

```bash
cd mision/proyecto
python3 herramientas/analizar.py < datos/ventas_2024.csv > informe.txt   # < entra, > guarda (Windows: python)
grep ERROR logs/app.log | wc -l >> informe.txt                           # >> añade
cd ../.. && bash comprobar.sh techo 4
```

- `echo $PATH`: ¿por qué `python3` funciona desde cualquier sitio y tu script necesita `./`?
- ¿Diferencia entre `AGENTE=x ./herramientas/revelar.sh` y `export AGENTE=x`? Prueba en una terminal nueva.

Siguiente: [Misión 5](05-automatiza.md) o entrega (README)
