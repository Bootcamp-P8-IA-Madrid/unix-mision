#!/usr/bin/env bash
# Comprueba que tu terminal sirve para las misiones. Uso: bash comprobar-entorno.sh
ok=0; avisos=0
echo "== Comprobando tu entorno =="
case "$(uname -s)" in
  Linux*)  so="Linux"; [ -n "$WSL_DISTRO_NAME" ] && so="WSL (Ubuntu dentro de Windows)";;
  Darwin*) so="macOS";;
  MINGW*|MSYS*|CYGWIN*) so="Windows con Git Bash";;
  *) so="desconocido ($(uname -s))";;
esac
echo "Sistema:   $so"
echo "Shell:     $BASH ($BASH_VERSION)"

if command -v python3 >/dev/null 2>&1 && python3 -c "print()" >/dev/null 2>&1; then
  echo "Python:    $(python3 --version 2>&1)  (usa: python3)"
elif command -v python >/dev/null 2>&1; then
  echo "Python:    $(python --version 2>&1)  (en tu sistema el comando es 'python', no 'python3')"
else
  echo "Python:    NO ENCONTRADO. Instálalo desde python.org y marca 'Add to PATH'."; avisos=$((avisos+1))
fi
if command -v git >/dev/null 2>&1; then echo "Git:       $(git --version)"; else echo "Git:       no instalado (solo lo necesitas si entregas por git)"; fi

for c in ls cd grep find chmod sort uniq wc head tail awk; do
  command -v $c >/dev/null 2>&1 || { echo "FALTA el comando: $c"; avisos=$((avisos+1)); }
done

if grep -q $'\r' "$0" 2>/dev/null; then
  echo "AVISO: este archivo tiene saltos de línea de Windows (CRLF). Ejecuta:  git config --global core.autocrlf false  y vuelve a clonar."
  avisos=$((avisos+1))
fi

case "$so" in
  *"Git Bash"*)
    echo ""
    echo "NOTA para Git Bash: Windows no tiene permisos UNIX de verdad."
    echo "  - chmod +x y chmod +r no cambian nada visible: los archivos se leen y ejecutan igual."
    echo "  - Haz los pasos de chmod de todas formas para acostumbrar los dedos; la misión te explica qué pasaría en Linux."
    echo "  - Todo lo demás (cd, ls, grep, mv, pipes, variables, python) funciona igual que en Linux.";;
esac

echo ""
if [ $avisos -eq 0 ]; then echo "Todo listo. Siguiente paso:  bash setup.sh"; else echo "Hay $avisos aviso(s) arriba. Si no sabes resolverlo, pregunta antes de seguir."; fi
