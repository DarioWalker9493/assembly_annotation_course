#!/usr/bin/env bash
set -euo pipefail

WORKDIR=/data/users/dwalker/assembly_annotation_course
cd "$WORKDIR/merqury_results_final"

{
printf "Assembly\tError_kmers\tTotal_kmers\tQV\tError_rate\t1_error_per_bp\tCompleteness_%%\n"

for n in flye hifiasm lja; do

    qv=$n/$n.qv
    cs=$n/$n.completeness.stats

    if [ ! -s "$qv" ] || [ ! -s "$cs" ]; then
        printf "%s\tmissing or empty output (check %s)\n" "$n" "$n/"
        continue
    fi

    comp=$(awk '
        $2=="all" {c=$NF}
        END {
            if(c=="") c=$NF
            print c
        }
    ' "$cs")

    awk -v n="$n" -v c="$comp" '
        NR==1 {
            inv = ($5 > 0) ? sprintf("%.0f", 1/$5) : "NA"

            printf "%s\t%d\t%d\t%.2f\t%.3e\t%s\t%.2f\n",
                   n, $2, $3, $4, $5, inv, c
        }
    ' "$qv"

done

} | tee merqury_summary.tsv | column -t -s$'\t'