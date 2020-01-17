#!/bin/#!/usr/bin/env bash

## ENVIRONMENTE VARIABLES REQUIRED
#format is: export VARNAME="value"
export LENGTH_REFERENCE="test/reference/lenght_of_REs.tsv"

# borrar resultados de prueba anterior
rm -fr test/results/
# Crear un test/results vacío
mkdir -p test/results
bash runmk.sh && mv test/data/*.summary.tsv test/data/*.png test/results/ \
 && echo "module test successful"
