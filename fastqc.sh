#!/bin/bash
#SBATCH --job-name=fastqc_all        # Job name
#SBATCH --time=01:00:00              # Max runtime
#SBATCH --partition=normal             # Partition
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8GB                    # Memory per CPU
#SBATCH --account=yourproject        # HPC project/account
#SBATCH --mail-user=aluochmathew@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --output=/home/maluoch/aluoch/project/fastqc_%j.out


echo "########################################"
echo "Job started at:" $(date)
echo "User:" $USER
echo "Job ID:" $SLURM_JOB_ID
echo "Directory:" $(pwd)
echo "########################################"


# Create folder for results
mkdir -p fastqc_results

# Run FastQC on all FASTQ files in the current directory
for file in *.fastq; do
    echo "Running FastQC on $file"
    fastqc -o fastqc_results "$file"
done

echo "########################################"
echo "Job finished at:" $(date --iso-8601=seconds)

