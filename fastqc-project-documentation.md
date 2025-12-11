
#!/bin/bash
#fastQC Analysis Workflow on HPC + GitHub Upload
# Author: Mathew Aluoch
# Email: aluochmathew@gmail.com
# Date: 2025-12-11
# Description: Download FASTQ data, run FastQC, and push results to GitHub

# connect to HPC by;
# ssh maluoch@hpc01.icipe.org
# Navigate to your working directory
cd ~
mkdir -p aluoch/project
cd aluoch/project
pwd

# 2. Download dataset
wget https://zenodo.org/record/61771/files/GSM461178_untreat_paired_subset_1.fastq
ls -lh
head GSM461178_untreat_paired_subset_1.fastq

# 3. Load FastQC
module avail fastqc
module load fastqc/0.11.9

# 4. Run FastQC
mkdir -p fastqc_results
fastqc GSM461178_untreat_paired_subset_1.fastq -o fastqc_results

# Run FastQC via SLURM batcht << EOF > fastqc.sh
#!/bin/bash
#SBATCH --error=fastqc_%j.err
#SBATCH --time=01:00:00
#SBATCH --partition=normal
#SBATCH --ntasks=1
#SBATCH --mem=8G

module load fastqc/0.11.9
fastqc GSM461178_untreat_paired_subset_1.fastq -o fastqc_results
EOF

chmod +x fastqc.sh
sbatch fastqc.sh
squeue
scontrol show -dd jobid=<JOBID>

#6. Retrieve FastQC results (local copy)

# scp maluoch@hpc01.icipe.org:/home/maluoch/aluoch/project/fastqc_results/*.html .

# 7. Git setup and commit
cd /home/maluoch/aluoch/project
git init
git add .
git commit -m "Initial commit: FastQC analysis"

# 8. Add GitHub repository and push via SSH
git remote add origin git@github.com:ALUOCH0/fastqc-project.git
git branch -M main

# Generate SSH key (if not done)
