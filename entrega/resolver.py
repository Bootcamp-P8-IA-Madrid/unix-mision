"""Misión 5 · Automatízalo. Pruébalo con:  bash comprobar.sh python"""
import os
import subprocess


def ejecutar(comando, env=None):
    """Ejecuta un comando de terminal y devuelve (salida, codigo_de_salida)."""
    print(f"ejecuto: {comando}")
    resultado = subprocess.run(
        ["bash", "-c", comando], capture_output=True, text=True,   # siempre bash, también en Windows
        env=env if env is not None else os.environ.copy(),
    )
    salida = (resultado.stdout + resultado.stderr).strip()
    if salida:
        print("   " + salida.replace("\n", "\n   ")[:400])
    return salida, resultado.returncode


def resolver():
    fragmentos = []

    # Fragmento 1: find + cat (carpeta oculta en proyecto/datos)
    salida, codigo = ejecutar("find proyecto -name fragmento1.txt -print -quit")
    if codigo != 0 or not salida:
        raise RuntimeError("No se encontró fragmento1.txt")
    salida, codigo = ejecutar(f"cat '{salida.splitlines()[0]}'")
    if codigo != 0:
        raise RuntimeError("No se pudo leer fragmento1.txt")
    fragmentos.append(salida.split("FRAGMENTO 1:", 1)[1].strip().splitlines()[0])

    # Fragmento 2: grep en proyecto/logs/app.log
    salida, codigo = ejecutar('grep -o "fragmento2=[A-Z0-9]*" proyecto/logs/app.log')
    if codigo != 0 or "fragmento2=" not in salida:
        raise RuntimeError("No se encontró fragmento2")
    fragmentos.append(salida.split("fragmento2=", 1)[1].splitlines()[0].strip())

    # Fragmento 3: mkdir + mv en proyecto/descargas, luego ejecutar('bash ../comprobar.sh orden')
    salida, codigo = ejecutar("cd proyecto/descargas && mkdir -p imagenes documentos datos")
    if codigo != 0:
        raise RuntimeError("No se pudieron crear las carpetas de descargas")
    movimientos = (
        ("*.jpg", "imagenes"),
        ("*.png", "imagenes"),
        ("*.pdf", "documentos"),
        ("*.txt", "documentos"),
        ("*.csv", "datos"),
        ("*.json", "datos"),
    )
    for patron, destino in movimientos:
        comando = (
            f"cd proyecto/descargas && "
            f"for archivo in {patron}; do "
            f"[ -e \"$archivo\" ] && mv \"$archivo\" {destino}/; "
            f"done"
        )
        salida, codigo = ejecutar(comando)
        if codigo != 0:
            raise RuntimeError(f"No se pudieron mover los archivos a {destino}")
    salida, codigo = ejecutar("cd proyecto && bash ../../comprobar.sh orden")
    if codigo != 0 or "FRAGMENTO 3:" not in salida:
        raise RuntimeError("No se pudo validar la misión de ordenación")
    fragmentos.append(salida.split("FRAGMENTO 3:", 1)[1].strip().splitlines()[0])

    # Fragmento 4: chmod +x y ejecutar('cd proyecto && ./herramientas/revelar.sh', env={**os.environ, "AGENTE": "robot"})
    ejecutar("chmod +x proyecto/herramientas/revelar.sh")
    entorno = {**os.environ, "AGENTE": "robot"}
    salida, codigo = ejecutar("cd proyecto && ./herramientas/revelar.sh", env=entorno)
    if codigo != 0 or "FRAGMENTO 4:" not in salida:
        raise RuntimeError("No se pudo revelar el fragmento 4")
    fragmentos.append(salida.split("FRAGMENTO 4:", 1)[1].strip().splitlines()[0])

    clave = "-".join(fragmentos)
    print(f"\nCLAVE: {clave}")
    return clave


if __name__ == "__main__":
    if not os.path.isdir("proyecto"):
        print("Ejecútame desde la carpeta mision/ :  cd mision && python3 ../entrega/resolver.py   (o python)")
        raise SystemExit(1)
    resolver()
