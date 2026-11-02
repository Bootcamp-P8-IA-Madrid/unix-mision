# Chuleta de terminal (Linux · macOS · Windows con Git Bash)

> `comando -opciones argumento`. Las opciones empiezan por `-`. Cualquier duda: `comando --help` en Linux y Git Bash, `man comando` en macOS (sal con `q`).

Todo lo de abajo funciona igual en los tres sistemas. Las únicas diferencias que te vas a encontrar:

| | Linux / WSL | macOS | Windows (Git Bash) |
|---|---|---|---|
| Tu casa `~` | `/home/tu_usuario` | `/Users/tu_usuario` | `/c/Users/tu_usuario` (es `C:\Users\...`) |
| Ejecutar Python | `python3` | `python3` (si pide instalar las Command Line Tools, acepta) | `python` (`python3` no suele existir; si dice *Permission denied* o abre la Microsoft Store, usa `python`) |
| Permisos (`chmod`) | funcionan | funcionan | no bloquean nada: Windows no tiene permisos UNIX. Haz el `chmod` igual |
| Ayuda | `ls --help` o `man ls` | `man ls` (`--help` no existe) | `ls --help` (no hay `man`) |
| Abrir la carpeta actual en el explorador | `xdg-open .` (WSL: `explorer.exe .`) | `open .` | `explorer .` |
| Copiar / pegar en la terminal | `Ctrl+Shift+C` / `Ctrl+Shift+V` | `Cmd+C` / `Cmd+V` | en VS Code: `Ctrl+C` con texto seleccionado / `Ctrl+V`. En la ventana de Git Bash: seleccionar copia, `Shift+Insert` pega |
| Shell por defecto | bash | zsh (igual para todo esto) | bash |
| Ruta con espacios | `cd "Mi carpeta"` | `cd "Mi carpeta"` | `cd "Mi carpeta"` (nunca `C:\`, siempre `/c/`) |

## Moverse
| Comando | Qué hace |
|---|---|
| `pwd` | ¿Dónde estoy? (ruta actual) |
| `ls` | ¿Qué hay aquí? |
| `ls -la` | Lo mismo, con detalles y archivos ocultos |
| `cd carpeta` | Entrar en una carpeta |
| `cd ..` | Subir un nivel |
| `cd ~` o `cd` | Ir a tu carpeta personal |
| `cd -` | Volver a donde estabas |

**Rutas:** `/` es la raíz del sistema, `~` tu casa, `.` aquí, `..` el padre. Una ruta que empieza por `/` es absoluta; si no, es relativa a donde estás.

## Ver y buscar
| Comando | Qué hace |
|---|---|
| `cat archivo` | Muestra el archivo entero |
| `less archivo` | Lo muestra por páginas (`/texto` busca, `q` sale) |
| `head -n 10 archivo` | Las 10 primeras líneas |
| `tail -n 10 archivo` | Las 10 últimas (`tail -f` sigue un log en vivo) |
| `grep palabra archivo` | Líneas que contienen la palabra (`-i` ignora mayúsculas, `-n` numera, `-r` busca en carpetas) |
| `wc -l archivo` | Cuenta líneas |
| `find . -name "*.csv"` | Busca archivos por nombre |

## Crear, copiar, mover, borrar
| Comando | Qué hace |
|---|---|
| `mkdir carpeta` | Crear carpeta (`-p` crea toda la ruta) |
| `touch archivo` | Crear archivo vacío |
| `cp origen destino` | Copiar (`-r` para carpetas) |
| `mv origen destino` | Mover **o renombrar** |
| `rm archivo` | Borrar (no hay papelera) |
| `rm -r carpeta` | Borrar carpeta con todo dentro |
| `*.jpg` | Comodín: todos los que acaban en .jpg |

## Permisos y ejecutar
| Comando | Qué hace |
|---|---|
| `ls -l` | Ver permisos: `-rwxr-xr--` = dueño / grupo / otros |
| `chmod +x script.sh` | Hacer ejecutable |
| `chmod +r archivo` | Dar permiso de lectura |
| `./script.sh` | Ejecutar un script de la carpeta actual |
| `python3 script.py` | Ejecutar Python |
| `export VAR=valor` | Crear variable de entorno (`echo $VAR` para verla) |
| `echo $PATH` | Carpetas donde el sistema busca comandos |

## Tuberías y redirecciones
| Símbolo | Qué hace |
|---|---|
| `a \| b` | La salida de `a` es la entrada de `b` |
| `a > archivo` | Guarda la salida en archivo (lo sobreescribe) |
| `a >> archivo` | Añade al final del archivo |
| `a < archivo` | Usa el archivo como entrada |
| `sort`, `uniq -c`, `cut`, `awk` | Ordenar, contar repetidos, cortar columnas |

Ejemplo: `grep ERROR app.log | sort | uniq -c | sort -rn | head -3`

## Trucos que te van a salvar
- **Tab** autocompleta nombres. Úsalo SIEMPRE.
- **↑ / ↓** recorre comandos anteriores. `history` los lista (en macOS: `history 1`).
- **Ctrl+C** cancela lo que está corriendo. **Ctrl+L** limpia pantalla. **Ctrl+R** busca en el historial.
- `q` sale de `less`, `man`, etc.
- Si algo pide "Permission denied": mira `ls -l` y piensa en `chmod`.
- Antes de un `rm` con `*`, haz `ls` con el mismo patrón para ver qué vas a borrar.
