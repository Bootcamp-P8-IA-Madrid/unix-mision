# Misión 5 · Automatízalo en Python (si ya vuelas)

Has resuelto la misión a mano. Ahora escribe un script de Python que la resuelva solo: que ejecute los mismos comandos de terminal que tú, lea lo que devuelven y saque la clave.

## PISO

1. Abre `entrega/resolver.py`. Ya tiene `ejecutar(comando)`: lanza un comando de terminal y devuelve su salida.
2. Completa `resolver()` para que encuentre los 4 fragmentos con `find`, `grep`, `mkdir`, `mv`, `chmod` y una variable de entorno, y los imprima como `F1-F2-F3-F4`.
3. Pruébalo sobre una misión limpia:
   ```bash
   bash setup.sh --reset      # borra mision/ y la recrea; tu progreso se conserva
   bash comprobar.sh python
   ```

Pistas: `find . -name fragmento1.txt` · `grep -o "fragmento2=[A-Z0-9]*"` · `bash ../comprobar.sh orden` · `env={**os.environ, "AGENTE": "robot"}`

## TECHO

- Cero rutas escritas a mano: todo con `find` y `grep`.
- Si un comando falla (`returncode != 0`), detéctalo y prueba otra cosa (ej. `Permission denied` → `chmod +x` y reintenta). Que el script reaccione a lo que ve, no que siga una lista cerrada.

Esto mismo, con un modelo decidiendo los comandos en vez de tú, es lo que más adelante llamaremos un agente. Hoy, el que decide eres tú.
