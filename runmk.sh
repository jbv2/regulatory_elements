#!/bin/bash

find -L . \
        -type f \
        -name "*.filtered.tsv" \
        ! -name "length_of_REs.tsv" \
| sed "s#.tsv#.summary.tsv#" \
| xargs mk $@
