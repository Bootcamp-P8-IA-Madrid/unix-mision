"""Misión 5: descubrir los fragmentos y reaccionar a los errores de la terminal."""
import os
import re
import shlex
import subprocess


def ejecutar(comando, env=None):
    """Ejecuta Bash y devuelve (salida, código de salida), también en Windows."""
    print(f"ejecuto: {comando}")
    resultado = subprocess.run(
        ["bash", "-c", comando], capture_output=True, text=True,
        encoding="utf-8", errors="replace",
        env=env if env is not None else os.environ.copy(),
    )
    salida = (resultado.stdout + resultado.stderr).strip()
    if salida:
        print("   " + salida.replace("\n", "\n   ")[:400])
    return salida, resultado.returncode


def exigir(comando, env=None):
    """No continuar con una salida incompleta si un comando falla."""
    salida, codigo = ejecutar(comando, env)
    if codigo != 0:
        raise RuntimeError(f"Falló ({codigo}): {comando}\n{salida}")
    return salida


def encontrar(nombre, tipo="f", base=".", profundidad=None):
    limite = f" -maxdepth {profundidad}" if profundidad else ""
    salida = exigir(
        f"find {shlex.quote(base)}{limite} -type {tipo} -name {shlex.quote(nombre)}"
    )
    rutas = salida.splitlines()
    if not rutas:
        # Si no aparece, ampliar la profundidad y tolerar cambios de mayúsculas.
        salida = exigir(
            f"find {shlex.quote(base)} -type {tipo} -iname {shlex.quote(nombre)}"
        )
        rutas = salida.splitlines()
    if len(rutas) != 1:
        raise RuntimeError(f"Esperaba una coincidencia para {nombre}; encontré {rutas}")
    return rutas[0]


def fragmento(texto, numero):
    coincidencias = re.findall(
        rf"\bfragmento\s*{numero}\s*[:=]\s*([A-Z0-9]+)\b", texto, re.IGNORECASE
    )
    valores = set(coincidencias)
    if len(valores) != 1:
        raise RuntimeError(f"No hay un fragmento {numero} inequívoco en la salida")
    return valores.pop()


def resolver():
    # Buscamos por nombre y contenido, nunca por una ruta completa conocida.
    primero = encontrar("fragmento1.txt")
    comando_lectura = f"grep -iE 'FRAGMENTO[[:space:]]+1:' {shlex.quote(primero)}"
    salida, codigo = ejecutar(comando_lectura)
    if codigo != 0 and "permission denied" in salida.lower():
        exigir(f"chmod u+r -- {shlex.quote(primero)}")
        salida = exigir(comando_lectura)
    elif codigo != 0:
        raise RuntimeError(f"No se pudo leer el primer fragmento ({codigo}): {salida}")
    fragmentos = [fragmento(salida, 1)]

    salida = exigir(
        "find . -type f -name '*.log' -exec grep -h -oE 'fragmento2=[A-Z0-9]+' {} +"
    )
    fragmentos.append(fragmento(salida, 2))

    comprobador = encontrar("comprobar.sh", base="..", profundidad=2)
    comprobar_orden = f"bash {shlex.quote(comprobador)} orden"
    salida = exigir(comprobar_orden)
    if not re.search(r"FRAGMENTO\s+3:", salida):
        # El comprobador devuelve 0 incluso cuando falta ordenar: leemos su mensaje.
        descargas = encontrar("descargas", tipo="d")
        grupos = {"imagenes": ("jpg", "png"), "documentos": ("pdf", "txt"),
                  "datos": ("csv", "json")}
        for carpeta, extensiones in grupos.items():
            destino = f"{descargas}/{carpeta}"
            exigir(f"mkdir -p -- {shlex.quote(destino)}")
            filtros = " -o ".join(f"-iname '*.{ext}'" for ext in extensiones)
            archivos = exigir(
                f"find {shlex.quote(descargas)} -maxdepth 1 -type f \\( {filtros} \\)"
            )
            for archivo in archivos.splitlines():
                # No sobrescribir archivos si el ejercicio se encuentra parcialmente resuelto.
                destino_archivo = f"{destino}/{archivo.rsplit('/', 1)[-1]}"
                exigir(f"test ! -e {shlex.quote(destino_archivo)}")
                exigir(f"mv -- {shlex.quote(archivo)} {shlex.quote(destino + '/')}")
        salida = exigir(comprobar_orden)
    fragmentos.append(fragmento(salida, 3))

    revelar = encontrar("revelar.sh")
    entorno = os.environ.copy()
    entorno.pop("AGENTE", None)  # Primero observamos qué necesita el programa.
    comando = shlex.quote(revelar)
    for intento in range(3):
        salida, codigo = ejecutar(comando, entorno)
        if codigo == 0:
            fragmentos.append(fragmento(salida, 4))
            break
        if codigo == 126 and "permission denied" in salida.lower():
            exigir(f"chmod +x -- {shlex.quote(revelar)}")
        elif "AGENTE" in salida and "AGENTE" not in entorno:
            # En Git Bash los permisos UNIX pueden no impedir la primera ejecución.
            exigir(f"chmod +x -- {shlex.quote(revelar)}")
            entorno["AGENTE"] = "ivan"
        else:
            raise RuntimeError(f"No sé recuperar este error ({codigo}): {salida}")
    else:
        raise RuntimeError("No se pudo ejecutar revelar.sh tras los reintentos")

    clave = "-".join(fragmentos)
    print(f"\nCLAVE: {clave}")
    return clave


if __name__ == "__main__":
    try:
        resolver()
    except (RuntimeError, OSError) as error:
        print(f"ERROR: {error}")
        raise SystemExit(1)
