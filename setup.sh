#!/usr/bin/env bash
# =============================================================
#  setup.sh · Monta la carpeta "mision/" (el proyecto destrozado)
#  Uso:  bash setup.sh           crea ./mision
#        bash setup.sh --reset   borra y vuelve a crear desde cero
#  Funciona en Linux, macOS, WSL y Git Bash (Windows).
# =============================================================
set -e
cd "$(dirname "$0")"

if [ "$1" = "--reset" ]; then
  chmod -R u+rwx mision 2>/dev/null || true
  rm -rf mision
fi
if [ -d mision ]; then
  echo "Ya existe la carpeta mision/. Para empezar de cero:  bash setup.sh --reset"
  exit 1
fi

mkdir -p mision/proyecto/datos/raw/2023/backup/.olvidado mision/proyecto/logs/old mision/proyecto/descargas mision/proyecto/.secretos mision/proyecto/herramientas
cd mision

cat > LEEME.txt <<'TXT'
========================================================
   MISION: LA CLAVE PERDIDA
========================================================
Un script descontrolado ha estado "ordenando" este proyecto
y lo ha dejado hecho un desastre. Antes de
irse, partio la CLAVE DE ACCESO en 4 fragmentos y los
escondio por el proyecto.

Tu mision: recuperar los 4 fragmentos usando SOLO la
terminal y reconstruir la clave:

      FRAGMENTO1-FRAGMENTO2-FRAGMENTO3-FRAGMENTO4

Las instrucciones de cada mision estan en la carpeta
misiones/ del repo. Cuando tengas un fragmento,
compruebalo desde la raiz del repo:

      bash comprobar.sh TU_FRAGMENTO

Pistas:
  1. El fragmento 1 esta en una carpeta muy, muy profunda... y oculta.
  2. El fragmento 2 esta en una linea de un log de 1.500 lineas.
  3. El fragmento 3 te lo dan cuando ordenes el caos de descargas/.
  4. El fragmento 4 te lo dara un script... si sabe quien eres.

La terminal no muerde. Suerte.
TXT

cat > proyecto/app.py <<'PY'
# App principal del proyecto (no hace gran cosa todavia)
def main():
    print("Hola desde app.py. Todo en orden... o no.")

if __name__ == "__main__":
    main()
PY
printf "requests==2.32.3\npandas==2.2.2\nopenai==1.40.0\n" > proyecto/requirements.txt
cat > proyecto/notas.txt <<'TXT'
TODO del proyecto
- Revisar los logs, hay demasiados errores en algun modulo
- Ordenar la carpeta descargas, es un caos
- Alguien ha dejado un archivo sin permisos en .secretos
- El script revelar.sh no se ejecuta, ver por que
TXT

# ---------- Datos ----------
ciudades=(Madrid Barcelona Valencia Sevilla Bilbao); planes=(free pro pro free enterprise)
productos=(teclado raton monitor cable webcam)
printf "id,nombre,ciudad,plan\n" > proyecto/datos/clientes.csv
for i in $(seq 1 40); do
  printf "%d,cliente_%02d,%s,%s\n" "$i" "$i" "${ciudades[$((i % 5))]}" "${planes[$((i % 5))]}"
done >> proyecto/datos/clientes.csv
for anio in 2023 2024; do
  printf "fecha,producto,unidades,importe\n" > "proyecto/datos/ventas_${anio}.csv"
  for i in $(seq 1 120); do
    mes=$(( (i % 12) + 1 )); dia=$(( (i % 27) + 1 )); unid=$(( (i * 7) % 9 + 1 )); imp=$(( unid * ((i * 13) % 40 + 10) ))
    printf "%d-%02d-%02d,%s,%d,%d\n" "$anio" "$mes" "$dia" "${productos[$((i % 5))]}" "$unid" "$imp"
  done >> "proyecto/datos/ventas_${anio}.csv"
done
printf "esto,es,un,archivo,viejo\n1,2,3,4,5\n" > proyecto/datos/raw/2023/backup/viejo.csv
printf "Casi... pero no. Sigue buscando. Pista: ls -la muestra lo que ls esconde.\n" > proyecto/datos/raw/2023/backup/leeme.txt
cat > proyecto/datos/raw/2023/backup/.olvidado/fragmento1.txt <<'TXT'
Enhorabuena, has llegado hasta aqui con cd y ls -la.

   FRAGMENTO 1:  L4

Compruebalo desde la raiz del repo:  bash comprobar.sh L4
TXT

# ---------- Logs (deterministas, 1500 lineas) ----------
modulos=(auth db api pagos cache)
: > proyecto/logs/app.log
for i in $(seq 1 1500); do
  r=$(( (i * 7919) % 100 ))
  if   [ $r -lt 72 ]; then nivel="INFO   "
  elif [ $r -lt 90 ]; then nivel="WARNING"
  else                     nivel="ERROR  "; fi
  mod=${modulos[$(( (i * 31 + (i / 7)) % 5 ))]}
  if [ "$mod" = "pagos" ] && [ $(( i % 3 )) -eq 0 ]; then nivel="ERROR  "; fi
  dia=$(( (i / 60) % 28 + 1 )); hora=$(( (i / 3) % 24 )); minu=$(( (i * 11) % 60 )); seg=$(( (i * 17) % 60 ))
  case "$nivel" in
    "INFO   ") msg="peticion procesada en $(( (i * 13) % 900 + 20 ))ms" ;;
    "WARNING") msg="respuesta lenta ($(( (i * 29) % 3000 + 1000 ))ms)" ;;
    *)         msg="fallo al conectar, reintento $(( i % 3 + 1 ))/3" ;;
  esac
  if [ $i -eq 843 ]; then
    printf "[2024-03-%02d %02d:%02d:%02d] INFO    api    fragmento2=T3RM1N4L (bien visto, grep es tu amigo)\n" "$dia" "$hora" "$minu" "$seg"
  else
    printf "[2024-03-%02d %02d:%02d:%02d] %s %-6s %s\n" "$dia" "$hora" "$minu" "$seg" "$nivel" "$mod" "$msg"
  fi
done >> proyecto/logs/app.log
for d in 01 02 04 05; do
  for i in $(seq 1 150); do printf "[2023-01-%s] TRACE linea %d sin nada interesante\n" "$d" "$i"; done > "proyecto/logs/old/trace_2023-01-$d.log"
done
yes "[2023-01-03] TRACE este archivo es ENORME y no sirve para nada. Si lo has encontrado con find/du/sort, bonus para ti." | head -n 20000 > proyecto/logs/old/trace_2023-01-03.log

# ---------- Descargas (caos) ----------
cd proyecto/descargas
for i in 01 02 03 04 05 06 07; do printf "JPEGFAKE\n" > "foto_$i.jpg"; done
for i in 01 02 03; do printf "PNGFAKE\n" > "captura_$i.png"; done
for i in q1 q2 q3 q4; do printf "informe trimestre $i\n" > "informe_$i.pdf"; done
for n in presupuesto contrato manual; do printf "documento $n\n" > "$n.pdf"; done
for n in a b c d e f; do printf "x,y\n1,2\n" > "datos_$n.csv"; done
printf '{"debug": true}\n' > config.json
printf '{"token": "nope"}\n' > ajustes.json
printf "recordatorio: ordenar esto\n" > notas.txt
printf "lista de la compra\n" > compra.txt
cd ../..

# ---------- Secretos (practica de permisos; en Git Bash no bloquea, ver mision 3) ----------
printf "API_KEY=esta-no-es-la-clave-que-buscas\nDEBUG=false\n" > proyecto/.secretos/.env
cat > proyecto/.secretos/caja_fuerte.txt <<'TXT'
Si estas leyendo esto en Linux, macOS o WSL, es porque has usado chmod +r. Bien.
Si estas en Git Bash (Windows), has entrado directamente: Windows no tiene
permisos UNIX y por eso en servidores (que son Linux) esto SI importa.

Bonus: el archivo mas grande del proyecto esta en logs/old. Encuentralo sin abrirlo.
TXT
chmod 000 proyecto/.secretos/caja_fuerte.txt

# ---------- Herramientas ----------
cat > proyecto/herramientas/saluda.py <<'PY'
import os, sys
print("Hola, soy un script de Python y me has ejecutado desde la terminal.")
print("Estoy en la carpeta:", os.getcwd())
print("Me has pasado", len(sys.argv) - 1, "argumento(s):", sys.argv[1:])
PY
cat > proyecto/herramientas/revelar.sh <<'SH'
#!/usr/bin/env bash
# Revela el fragmento 4... pero solo a quien se identifique.
if [ -z "$AGENTE" ]; then
  echo "Acceso denegado: no se quien eres."
  echo "Define la variable de entorno AGENTE con tu nombre y vuelve a ejecutarme:"
  echo "    export AGENTE=tu_nombre"
  echo "    ./herramientas/revelar.sh"
  exit 1
fi
echo "Hola, $AGENTE. Identidad confirmada."
echo ""
echo "   FRAGMENTO 4:  MU3RD3"
echo ""
echo "Compruebalo desde la raiz del repo:  bash comprobar.sh MU3RD3"
SH
chmod -x proyecto/herramientas/revelar.sh
cat > proyecto/herramientas/analizar.py <<'PY'
# Lee un CSV de ventas por la entrada estandar (stdin) y resume.
# Uso:  python3 herramientas/analizar.py < datos/ventas_2024.csv
import sys, csv
from collections import Counter
filas = list(csv.DictReader(sys.stdin))
if not filas:
    print("No he recibido datos. Usa:  python3 herramientas/analizar.py < datos/ventas_2024.csv")
    sys.exit(1)
total = sum(int(f["importe"]) for f in filas)
por_producto = Counter()
for f in filas:
    por_producto[f["producto"]] += int(f["importe"])
print("# Informe de ventas")
print(f"Filas: {len(filas)}")
print(f"Importe total: {total}")
print("Top productos:")
for prod, imp in por_producto.most_common(3):
    print(f"  - {prod}: {imp}")
PY

cd ..
echo ""
echo "Listo. La mision esta en mision/. Empieza con:   cat mision/LEEME.txt   y luego   cat misiones/01-moverse.md"
