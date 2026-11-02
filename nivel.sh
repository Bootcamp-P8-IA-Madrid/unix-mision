#!/usr/bin/env bash
# Autodiagnóstico de 2 minutos. Te dice por qué misión empezar. Uso: bash nivel.sh
echo "Responde s (sí) o n (no). Sin trampas: nadie lo ve más que tú."
echo ""
p=0
pregunta() { read -r -p "$1 [s/n] " r; case "$r" in s|S|si|sí|y) p=$((p+1));; esac; }
pregunta "1. ¿Sabes qué hace 'cd ..' sin probarlo?"
pregunta "2. ¿Has usado grep alguna vez para buscar texto en un archivo?"
pregunta "3. ¿Sabes qué significa '-rwxr-xr--' en un ls -l?"
pregunta "4. ¿Has encadenado dos comandos con | (tubería)?"
pregunta "5. ¿Has ejecutado un script con ./script.sh y te ha dado 'Permission denied' alguna vez?"
echo ""
if [ $p -le 1 ]; then
  echo "Empieza por la misión 1 y haz el PISO de cada una con calma. El TECHO es opcional."
elif [ $p -le 3 ]; then
  echo "Haz la misión 1 rápido (5 min) y a partir de la 2 ve a por el TECHO."
else
  echo "Haz el PISO de las 4 misiones a toda velocidad (son 15 min para ti), ve a por los TECHOS y luego a la misión 5: automatizarlo en Python."
  echo "Y recuerda: cuando termines, eres mentor de tu mesa. Hablas, no tecleas."
fi
