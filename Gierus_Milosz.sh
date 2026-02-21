#!/bin/bash

ENV_FILE="/tmp/env_manager_vars"


file_tymczasowy() {
  if [[ ! -f "$ENV_FILE" ]]; then
    	skroconePATH=$(echo "$PATH" | tr ':' '\n' | grep -E '^/usr/bin$|^/bin$' | paste -sd ':')
	echo "PATH=$skroconePATH" >> "$ENV_FILE"
    	echo "HOME=$HOME" >> "$ENV_FILE"
  fi
}

dodawanie() {
  local var="$1"
  
  if [[ ! "$var" =~ ^[A-Za-z_][A-Za-z0-9_]*=.*$ ]]; then
    echo "Poprawny format: $0 NAME=VALUE"
    exit 1
  fi

  local name="${var%%=*}"
  local value="${var#*=}"

  if grep -q "^$name=" "$ENV_FILE"; then
    echo "$name - istnieje, podaj inna nazwe"
    exit 1
  fi

  echo "$name=$value" >> "$ENV_FILE"
  echo "Added $name"
}

lista() {
  cat "$ENV_FILE"
}

usuwanie() {
  local name="$1"
  
  if [[ -z "$name" ]]; then
    echo "Poprawny format: $0 remove <NAME>"
    exit 1
  fi

  if ! grep -q "^$name=" "$ENV_FILE"; then
    echo "$name - nie istnieje"
    exit 1
  fi

  sed -i "/^$name=/d" "$ENV_FILE"
  echo "Removed $name"
}

command="$1"
arg="$2"

file_tymczasowy

case "$command" in
  add)
    if [[ -z "$arg" ]]; then
      echo "poprawny format: $0 add <NAME>=<VALUE>"
      exit 1
    fi
    dodawanie "$arg"
    ;;
  list)
    lista
    ;;
  remove)
    if [[ -z "$arg" ]]; then
      echo "poprawny format: $0 remove <NAME>"
      exit 1
    fi
    usuwanie "$arg"
    ;;
  *)
    	echo ""
	echo "Przypadki użycia:" 
	echo ""
	echo "$0 list                      -Wyświetlanie"
	echo "$0 add <NAME>=<VALUE>        -Dodawanie"
	echo "$0 remove <NAME>             -Usuwanie"
    ;;
esac