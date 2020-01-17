MKSHELL=/bin/bash
#Definir MKSHELL ahora debe ir siempre arriba con /bin/bash. "Todo lo que viene a continuación interprétalo con bash"

# Este bloque toma una tabla de variantes en GH y resume.
%.summary.tsv:Q: %.tsv $LENGTH_REFERENCE
	echo "[DEBUG] making summary of $prereq file"
	echo "[DEBUG] el primer elemento es $stem.tsv"
	echo "[DEBUG] El segundo elemento es $LENGTH_REFERENCE"
	Rscript --vanilla summarizer.R $stem.tsv $LENGTH_REFERENCE $target
