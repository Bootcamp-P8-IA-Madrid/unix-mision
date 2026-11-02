# La clave perdida · misiones de terminal

Un script descontrolado ha destrozado un proyecto y ha escondido la clave de acceso en 4 fragmentos. Recupéralos usando solo la terminal.

## 1. Abre el repo en VS Code y una terminal UNIX

Archivo → Abrir carpeta (esta). Luego Terminal → Nuevo terminal y en el desplegable `+ ˅` elige:

| Sistema | Terminal |
|---|---|
| Windows | **Git Bash**. Si el prompt empieza por `PS C:\` o `ls -la` te dice *A parameter cannot be found that matches parameter name 'la'*, estás en PowerShell: cambia. |
| macOS | la que sale (zsh). Ya es UNIX. |
| Linux / WSL | la que sale. |

**Windows, si Git Bash no aparece en el desplegable:** reinicia VS Code. Si sigue sin salir, botón derecho sobre la carpeta del repo en el Explorador de archivos (Windows 11: "Mostrar más opciones") → **Git Bash Here**, y sigue desde el paso 2 ahí.
**Si en tu Windows no hay manera:** en GitHub, botón verde `Code → Codespaces → Create codespace`. Se abre un VS Code en el navegador con un Linux de verdad y el repo ya dentro. Sigue desde el paso 2.

## 2. Empieza

```bash
bash comprobar-entorno.sh   # ¿tu terminal sirve?
bash setup.sh               # crea la carpeta mision/
bash nivel.sh               # 5 preguntas: te dice por dónde empezar
```

## 3. Misiones

| # | Misión | Fragmento |
|---|---|---|
| 1 | [Moverse](misiones/01-moverse.md) · `pwd` `ls` `cd` | 1 |
| 2 | [Buscar](misiones/02-buscar.md) · `grep` `head` `tail` `\|` | 2 |
| 3 | [Ordenar](misiones/03-ordenar.md) · `mkdir` `mv` `*` `chmod` | 3 |
| 4 | [Ejecutar](misiones/04-ejecutar.md) · `./script` `export` `>` | 4 |
| 5 | [Automatízalo](misiones/05-automatiza.md) · Python (si ya vuelas) | |

Cada misión tiene **PISO** (todo el mundo, te da el fragmento) y **TECHO** (si sabes un poco mas). Usa la [chuleta](CHULETA.md) en caso de ser necesario.

## 4. Comprueba

Cada misión empieza y se comprueba **desde esta carpeta**. Si `comprobar.sh` dice *No such file*, sube con `cd ..` hasta que `ls` lo muestre.

```bash
bash comprobar.sh FRAGMENTO         # un fragmento
bash comprobar.sh orden             # misión 3: ¿descargas ordenada?
bash comprobar.sh techo 1 NUMERO    # un techo
bash comprobar.sh F1-F2-F3-F4       # la clave completa
bash comprobar.sh python            # misión 5
bash comprobar.sh gracias NOMBRE    # registra quién te ayudó
bash comprobar.sh progreso          # tu tabla
bash setup.sh --reset               # si rompes algo
```

## 5. Entrega (tú eliges)

- **A · Sin git:** `bash comprobar.sh progreso` y captura de pantalla.
- **B · Con git (reto):** fork del repo, `git add entrega/`, `git commit -m "Entrega NOMBRE"`, `git push` y pull request. No lo explicamos: averiguarlo es el reto.
