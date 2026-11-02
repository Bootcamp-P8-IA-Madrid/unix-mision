# Misión 5 · Tu primer agente (Python, si ya vuelas)

Un agente de IA con herramientas es un bucle: decide un comando, lo ejecuta, lee la salida, decide el siguiente. Hoy el cerebro eres tú. En unas semanas será un modelo.

## PISO

1. Abre `entrega/agente.py`. Ya tiene `ejecutar(comando)`: lanza un comando y devuelve su salida.
2. Completa `resolver()` para que encuentre los 4 fragmentos con `find`, `grep`, `mkdir`, `mv`, `chmod` y una variable de entorno, y los imprima como `F1-F2-F3-F4`.
3. Pruébalo sobre una misión limpia:
   ```bash
   bash setup.sh --reset      # borra mision/ y la recrea; tu progreso se conserva
   bash comprobar.sh agente
   ```

Pistas: `find . -name fragmento1.txt` · `grep -o "fragmento2=[A-Z0-9]*"` · `bash ../comprobar.sh orden` · `env={**os.environ, "AGENTE": "robot"}`

## TECHO

- Cero rutas escritas a mano: todo con `find` y `grep`.
- Imprime en cada paso `pienso: ...` y `ejecuto: ...`, como un agente real.
- Si un comando falla (`returncode != 0`), detéctalo y prueba otra cosa (ej. `Permission denied` → `chmod +x` y reintenta). Eso es lo que separa un script de un agente.
