#! /bin/bash

start=$SECONDS
echo $HOSTNAME

echo $"Written by"  'Marion Nyaboke' | sed $'s/Marion Nyaboke  🍷🐒😍 ☣ 🇩🇪 /\e[32m&\e[0m/';

echo $"This is" 'FastQC MultiQC Snippy Rapid Salmonella SNP Calling Script  Version 1.0.0' | sed $'s/FastQC MultiQC Snippy Salmonella SNP Calling Script  Version 1.0.0/\e[36m&\e[0m/';

cd ~/Documents/Salmonella

echo $"Now Running FastQC for the Samples" | sed $'s/Now Running FastQC for the Samples/\e[32m&\e[0m/';

for sample in `cat list.txt`
do

   fastqc ${sample}*_1.fastq ${sample}*_2.fastq

done

echo $"Now Running MultiQC for the Samples" | sed $'s/Now Running MultiQC for the Samples/\e[36m&\e[0m/';

multiqc .

echo $"Now Running minimap2 for the Samples" | sed $'s/Now Running minimap2 for the Samples/\e[33m&\e[0m/';


for sample in `cat list.txt`
do

  R1=${sample}_1.fastq
  R2=${sample}_2.fastq

    minimap2 -a salmonella_ref.fasta $R1 $R2 > salmonella.sam

    samtools view -S -b salmonella.sam > salmonella.bam

done 

echo $"Now Running ariant calling with freebayes" | sed $'s/Now Running ariant calling with freebayes/\e[33m&\e[0m/';

freebayes -f salmonella_ref.fasta salmonella.bam > salmonella.vcf

echo $"Now downloading Salmonella database that will be used to annotate our data" | sed $'s/Now downloading Salmonella database that will be used to annotate our data/\e[33m&\e[0m/';

java -jar snpEff.jar download -v Salmonella_enterica_subsp_enterica_serovar_typhimurium_var_5_gca_001244255

echo $"Now using snpEff to annotate" | sed $'s/Now using snpEff to annotate/\e[33m&\e[0m/';

java -Xmx8g -jar snpEff.jar -v -stats ex1.html Salmonella_enterica_subsp_enterica_serovar_typhimurium_var_5_gca_001244255 salmonella.vcf > salmonella.ann.vcf

done
exit
