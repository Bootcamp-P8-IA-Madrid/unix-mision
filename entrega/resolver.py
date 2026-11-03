"""Misión 5 · Automatízalo. Pruébalo con:  bash comprobar.sh python"""
import os
import re
import shlex
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

    # Fragmento 1: descubrir el archivo, sin asumir la profundidad de la ruta.
    salida, codigo = ejecutar("find . -type f -name fragmento1.txt -print -quit")
    if codigo != 0 or not salida:
        raise RuntimeError("No se encontró fragmento1.txt")
    fragmento1_path = salida.splitlines()[0]
    salida, codigo = ejecutar(f"cat {shlex.quote(fragmento1_path)}")
    if codigo != 0:
        raise RuntimeError("No se pudo leer fragmento1.txt")
    match = re.search(r"FRAGMENTO 1:\s*(\S+)", salida)
    if not match:
        raise RuntimeError("La salida no contiene el fragmento 1")
    fragmentos.append(match.group(1))

    # Fragmento 2: descubrir el log y pedirle a grep solo la coincidencia.
    salida, codigo = ejecutar("find . -type f -name app.log -print -quit")
    if codigo != 0 or not salida:
        raise RuntimeError("No se encontró app.log")
    log_path = salida.splitlines()[0]
    salida, codigo = ejecutar(
        f'grep -o "fragmento2=[A-Z0-9]*" {shlex.quote(log_path)}'
    )
    if codigo != 0 or "fragmento2=" not in salida:
        raise RuntimeError("No se encontró fragmento2")
    fragmentos.append(salida.split("fragmento2=", 1)[1].splitlines()[0].strip())

    # Fragmento 3: descubrir descargas, crear categorías y mover por extensión.
    salida, codigo = ejecutar("find . -type d -name descargas -print -quit")
    if codigo != 0 or not salida:
        raise RuntimeError("No se encontró la carpeta descargas")
    descargas = salida.splitlines()[0]
    descargas_q = shlex.quote(descargas)
    salida, codigo = ejecutar(
        f"mkdir -p {descargas_q}/imagenes {descargas_q}/documentos {descargas_q}/datos"
    )
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
            f"find {descargas_q} -maxdepth 1 -type f -name {shlex.quote(patron)} "
            f"-exec mv {{}} {descargas_q}/{destino}/ \\;"
        )
        salida, codigo = ejecutar(comando)
        if codigo != 0:
            raise RuntimeError(f"No se pudieron mover los archivos a {destino}")
    salida, codigo = ejecutar("find .. -maxdepth 1 -type f -name comprobar.sh -print -quit")
    if codigo != 0 or not salida:
        raise RuntimeError("No se encontró comprobar.sh")
    checker = shlex.quote(salida.splitlines()[0])
    salida, codigo = ejecutar(f"bash {checker} orden")
    if codigo != 0 or "FRAGMENTO 3:" not in salida:
        raise RuntimeError("No se pudo validar la misión de ordenación")
    match = re.search(r"FRAGMENTO 3:\s*(\S+)", salida)
    if not match:
        raise RuntimeError("La salida no contiene el fragmento 3")
    fragmentos.append(match.group(1))

    # Fragmento 4: descubrir el script y reaccionar a un posible fallo de permisos.
    salida, codigo = ejecutar("find . -type f -name revelar.sh -print -quit")
    if codigo != 0 or not salida:
        raise RuntimeError("No se encontró revelar.sh")
    revelar = salida.splitlines()[0]
    revelar_dir = os.path.dirname(revelar) or "."
    revelar_name = os.path.basename(revelar)
    entorno = {**os.environ, "AGENTE": "robot"}
    comando_revelar = (
        f"cd {shlex.quote(revelar_dir)} && ./{shlex.quote(revelar_name)}"
    )
    salida, codigo = ejecutar(comando_revelar, env=entorno)
    if codigo != 0:
        salida, codigo = ejecutar(f"chmod +x {shlex.quote(revelar)}")
        if codigo != 0:
            raise RuntimeError("No se pudo corregir el permiso de revelar.sh")
        salida, codigo = ejecutar(comando_revelar, env=entorno)
    if codigo != 0 or "FRAGMENTO 4:" not in salida:
        raise RuntimeError("No se pudo revelar el fragmento 4")
    match = re.search(r"FRAGMENTO 4:\s*(\S+)", salida)
    if not match:
        raise RuntimeError("La salida no contiene el fragmento 4")
    fragmentos.append(match.group(1))

    clave = "-".join(fragmentos)
    print(f"\nCLAVE: {clave}")
    return clave


if __name__ == "__main__":
    marca, codigo = ejecutar(
        "find . -maxdepth 3 -type f -name app.py -print -quit"
    )
    if codigo != 0 or not marca:
        print("No encuentro la estructura de la misión.")
        print("Ejecútame desde la carpeta mision/.")
        raise SystemExit(1)
    resolver()