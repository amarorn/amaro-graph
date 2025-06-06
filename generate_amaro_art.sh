#!/bin/bash

set -e

REPO_NAME="amaro-graph"
GIT_USER_NAME="AMARO"
GIT_USER_EMAIL="j.amarorn@email.com"

# Matriz 7x52 com "pixels" desenhando "Amaro"
# Cada subarray representa uma coluna de dias (de domingo a sábado)
# '1' = faz commit, '0' = não faz
declare -a pixels=(
  # A
  01110 10001 11111 10001 10001 00000 00000
  # M
  10001 11011 10101 10001 10001 00000 00000
  # A
  01110 10001 11111 10001 10001 00000 00000
  # R
  11110 10001 11110 10100 10010 00000 00000
  # O
  01110 10001 10001 10001 01110 00000 00000
)

# Configurações iniciais
rm -rf $REPO_NAME
mkdir $REPO_NAME
cd $REPO_NAME
git init
git config user.name "$GIT_USER_NAME"
git config user.email "$GIT_USER_EMAIL"

# Data de início em janeiro de 2024
START_DATE=$(date -j -f "%Y-%m-%d" "2024-01-01" "+%s")

offset=0
for column in "${pixels[@]}"; do
  for row in {0..6}; do
    pixel=${column:$row:1}
    if [[ "$pixel" == "1" ]]; then
      # Calcula a data do commit
      commit_date=$(date -j -f "%s" "$((START_DATE + (offset * 86400) + (row * 86400)))" "+%a %b %d %Y 12:00:00")
      GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" \
      bash -c "echo $commit_date >> commits.txt && git add commits.txt && git commit -m 'pixel commit' > /dev/null"
    fi
  done
  ((offset++))
done

echo "✅ Repositório pronto! Agora adicione o remote:"
echo "   cd $REPO_NAME"
echo "   git remote add origin https://github.com/amarorn/amaro-graph.git"
echo "   git branch -M main"
echo "   git push -u origin main"