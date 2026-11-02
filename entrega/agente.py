"""Misión 5 · Tu primer agente. Pruébalo con:  bash comprobar.sh agente"""
import os
import subprocess


def ejecutar(comando, env=None):
    """Tu única herramienta: ejecuta un comando y devuelve (salida, codigo_de_salida)."""
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
    # TODO

    # Fragmento 2: grep en proyecto/logs/app.log
    # TODO

    # Fragmento 3: mkdir + mv en proyecto/descargas, luego ejecutar('bash ../comprobar.sh orden')
    # TODO

    # Fragmento 4: chmod +x y ejecutar('cd proyecto && ./herramientas/revelar.sh', env={**os.environ, "AGENTE": "robot"})
    # TODO

    clave = "-".join(fragmentos)
    print(f"\nCLAVE: {clave}")
    return clave


if __name__ == "__main__":
    if not os.path.isdir("proyecto"):
        print("Ejecútame desde la carpeta mision/ :  cd mision && python3 ../entrega/agente.py   (o python)")
        raise SystemExit(1)
    resolver()
