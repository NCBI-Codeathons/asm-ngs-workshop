cut -f 3 singapore_samples_srafull.txt | perl -ne 'BEGIN { print "--env ERR\t--output ASM\n" }
        chomp;
        print join("\t",
                "$_",
                "gs://asm-ngs-$USER/project1/step2/asm/$_.asm.fa"), "\n"
        '
