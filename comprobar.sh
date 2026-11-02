#!/usr/bin/env bash
# Comprueba fragmentos, techos y la clave final. Guarda tu progreso en entrega/progreso.txt
#
#   bash comprobar.sh FRAGMENTO          (ej: bash comprobar.sh XXXX)
#   bash comprobar.sh F1-F2-F3-F4        (clave final)
#   bash comprobar.sh orden              (misión 3: ¿descargas ordenada?)
#   bash comprobar.sh techo N RESPUESTA  (ej: bash comprobar.sh techo 1 123)
#   bash comprobar.sh agente             (misión 5: ejecuta tu entrega/agente.py)
#   bash comprobar.sh gracias NOMBRE     (registra quién te ha ayudado)
#   bash comprobar.sh progreso           (muestra tu tabla)
cd "$(dirname "$0")" || exit 1
P=entrega/progreso.txt
mkdir -p entrega; touch "$P"

hash() { if command -v sha256sum >/dev/null 2>&1; then printf "%s" "$1" | sha256sum | cut -d' ' -f1; else printf "%s" "$1" | shasum -a 256 | cut -d' ' -f1; fi; }
marca() { grep -qx "$1" "$P" || echo "$1" >> "$P"; }
py() { if command -v python3 >/dev/null 2>&1 && python3 -c "print()" >/dev/null 2>&1; then echo python3; else echo python; fi; }

progreso() {
  echo ""
  echo "  Misión                     PISO   TECHO"
  for i in 1 2 3 4; do
    nombres=("" "1 Moverse" "2 Buscar" "3 Ordenar" "4 Ejecutar")
    pi=" - "; te=" - "
    grep -qx "piso$i" "$P" && pi=" X "; grep -qx "techo$i" "$P" && te=" X "
    printf "  %-26s %s    %s\n" "${nombres[$i]}" "$pi" "$te"
  done
  pi=" - "; grep -qx "piso5" "$P" && pi=" X "
  printf "  %-26s %s\n" "5 Tu primer agente" "$pi"
  grep -qx "clave" "$P" && echo "" && echo "  CLAVE COMPLETA: sí"
  m=$(grep "^mentor:" "$P" | cut -d: -f2 | sort -u | tr '\n' ' ')
  [ -n "$m" ] && echo "  Te han ayudado: $m"
  echo ""
}

[ -z "$1" ] && { sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

case "$1" in
  progreso) progreso; exit 0;;
  gracias)
    [ -z "$2" ] && { echo "Uso: bash comprobar.sh gracias NOMBRE"; exit 1; }
    echo "mentor:$2" >> "$P"; echo "Registrado: $2 te ha ayudado. Eso cuenta para su techo."; exit 0;;
  orden)
    d=mision/proyecto/descargas
    [ -d "$d" ] || { echo "No encuentro mision/proyecto/descargas. ¿Has ejecutado bash setup.sh?"; exit 1; }
    sueltos=$(find "$d" -maxdepth 1 -type f | wc -l | tr -d ' ')
    if [ "$sueltos" -eq 0 ] && [ -d "$d/imagenes" ] && [ -d "$d/documentos" ] && [ -d "$d/datos" ] \
       && [ "$(ls "$d/imagenes" | wc -l | tr -d ' ')" -ge 10 ] && [ "$(ls "$d/datos" | wc -l | tr -d ' ')" -ge 8 ]; then
      echo "Descargas ordenada. Cero archivos sueltos."
      echo ""
      echo "   FRAGMENTO 3:  N0"
      echo ""
      echo "Compruébalo:  bash comprobar.sh N0"
    else
      echo "Todavía hay $sueltos archivo(s) sueltos en $d, o faltan carpetas imagenes/ documentos/ datos/, o están incompletas."
    fi
    exit 0;;
  techo)
    n=$2; r=$(printf "%s" "$3" | tr 'A-Z' 'a-z')
    case "$n" in
      1) [ "$(hash "$r")" = "31489056e0916d59fe3add79e63f095af3ffb81604691f21cad442a85c7be617" ] && { marca techo1; echo "Techo 1 correcto: ese es el número de archivos."; } || echo "No. Cuenta solo archivos (no carpetas), incluidos los ocultos. Pista: find ... -type f | wc -l";;
      2) [ "$(hash "$r")" = "f916f0e2b7eb12d73d918f46e541201aef723186b49d52b4c82695ec676200d1" ] && { marca techo2; echo "Techo 2 correcto: ese módulo es el que más falla."; } || echo "No. Pista: grep ERROR ... | awk '{print \$4}' | sort | uniq -c | sort -rn";;
      3) if [ -d mision/proyecto/datos_backup ] && ls mision/proyecto/descargas/imagenes/vacaciones_01.jpg >/dev/null 2>&1; then marca techo3; echo "Techo 3 correcto: backup hecho y fotos renombradas."; else echo "Falta datos_backup/ (cp -r) o las fotos vacaciones_01.jpg... (bucle for)."; fi;;
      4) f=mision/proyecto/informe.txt
         if [ -f "$f" ] && grep -q "Importe total" "$f" && tail -1 "$f" | grep -qE '^ *[0-9]+ *$'; then marca techo4; echo "Techo 4 correcto: informe generado con < > y la cuenta de errores añadida con >>."; else echo "Falta mision/proyecto/informe.txt con el informe (python3 ... < ... > informe.txt) y al final el número de errores (>> informe.txt)."; fi;;
      *) echo "Uso: bash comprobar.sh techo N RESPUESTA   (N de 1 a 4)";;
    esac
    exit 0;;
  agente)
    [ -f entrega/agente.py ] || { echo "No existe entrega/agente.py. Lee misiones/05-agente.md"; exit 1; }
    echo "Ejecutando tu agente sobre mision/ ..."
    salida=$(cd mision && $(py) ../entrega/agente.py 2>&1); echo "$salida" | tail -15
    if echo "$salida" | grep -q "L4-T3RM1N4L-N0-MU3RD3"; then marca piso5; echo ""; echo "TU AGENTE HA RESUELTO LA MISIÓN SOLO. Eso es un agente con herramientas."; else echo ""; echo "Tu agente todavía no imprime la clave completa. Sigue."; fi
    exit 0;;
esac

h=$(hash "$(printf "%s" "$1" | tr 'a-z' 'A-Z')")
case "$h" in
  4a5a97c6433c4c062457e9335709d57493e75527809d8a9586c141e591ac9f2c) marca piso1; echo "Fragmento 1 correcto. Te quedan 3.";;
  2aed8765e96c95cbc9dc304ca7fc1d12841f44cc18e5c5f4c14a225cd8c5445b) marca piso2; echo "Fragmento 2 correcto. Te quedan 2.";;
  f42d38c6240e4bcc35388e8a2ed07df04e506f6a59e667a6f698c74634053b73) marca piso3; echo "Fragmento 3 correcto. Te queda 1.";;
  c5a13a0e8ee6d7790ab2bda33ec79ffd822486a7625f99c463b8d1b748985195) marca piso4; echo "Fragmento 4 correcto. Ya tienes los 4: júntalos con guiones.";;
  1522e42617747aec826b79ec008d08012a38de6c2cc9fe9eefdb3a910b98f537)
    marca clave
    echo ""
    echo "  ██████  CLAVE CORRECTA  ██████"
    echo ""
    echo "  Lo has leído bien: LA TERMINAL NO MUERDE."
    echo "  Misión completada. Ahora ayuda a quien tengas al lado."
    progreso;;
  *) echo "Mmm... eso no es ningún fragmento ni una orden que conozca. Sigue buscando (o lee la ayuda: bash comprobar.sh)";;
esac
