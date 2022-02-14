#! /bin/bash
source scripts/chess.sh

mkdir -p html

main "$1" "$2" "$3" "resources/template.html" "resources/template.css" "html"
open html/index.html