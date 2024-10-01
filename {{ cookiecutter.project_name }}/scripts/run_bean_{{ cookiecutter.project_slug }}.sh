#!/bin/bash

### Parameters for specifying hardware resources
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=18
#SBATCH --partition=cpu
#SBATCH --mem=32G
#SBATCH --time=6:00:00
#SBATCH --account=cpr_nilsson  
## Optional info 
#SBATCH --job-name=Bean_Emil_ABE     # Job name
#SBATCH --output=output_contd.log    # Output file
#SBATCH --error=error_contd.log      # Error file


#####################################################################




screen_id={{ cookiecutter.project_slug }}
working_dir={{ cookiecutter.project_dir }}             # absolute path of working directory (use pwd)
output_dir=output1      # output path, replace name
sample_list=input/metafiles/{{ cookiecutter.project_slug }}_sample_list.csv
guide_list={{ cookiecutter.project_slug }}_guide_list.csv
reporter_length=32
gstart_reporter=6
guide_start_seq=GACGAAACACCG
barcode_start_seq=GTTTGAATTCGC
control_condition=D0
lfc_cond1=D0
lfc_cond2=D16
gene_symbols_file={{ cookiecutter.project_slug }}_gene_symbols.csv

cd $working_dir
###############################################
### Setup conda environment ###


module load miniconda/4.12.0

source /opt/software/miniconda/4.12.0/etc/profile.d/conda.sh

conda activate beanmads

################################################
### bean count ###

bean count-samples \
    -i "$working_dir/$sample_list" \
    -b A \
    -f "$working_dir/$guide_list" \
    -o "$output_dir" \
    -r \
    -n "$screen_id" \
    --tiling \
    --guide-start-seq="$guide_start_seq" \
    --barcode-start-seq="$barcode_start_seq" \
    --reporter-length="$reporter_length" \
    --gstart-reporter="$gstart_reporter" \
    -t 24 \
    --skip-filtering         #reads generally come prefiltered from the platform, this skips. are you unsure, remove it and the "\" in the above line


# ####################################################################################################
# Python script to calculate guide edits (will be implemented in bean future)
python calc_guide_edits.py $working_dir $screen_id $output_dir -c $control_condition


# ####################################################################################################
# ### Bean profile

bean profile $working_dir/${output_dir}/bean_count_${screen_id}_wedits.h5ad --pam-col '5-nt PAM' \
    --control-condition=$control_condition

####################################################################################################
### Bean qc

bean qc \
  ${output_dir}/bean_count_${screen_id}_wedits.h5ad            `# Input ReporterScreen .h5ad file path` \
  -o ${working_dir}/${output_dir}/${screen_id}_masked.h5ad `# Output ReporterScreen .h5ad file path` \
  -r ${working_dir}/${output_dir}/${screen_id}_qc_report_${screen_id} \
  --lfc-conds $lfc_cond1,$lfc_cond2 \
  --control-condition=$control_condition

####################################################################################################
### Bean filter
# look into https://www.youtube.com/watch?v=T4E0Ez5Vjz8

bean filter ${working_dir}/${output_dir}/${screen_id}_masked.h5ad \
    -o ${output_dir}/${screen_id}_Filtered \
    --filter-target-basechange                             `# Filter based on intended base changes. If -b A was provided in bean count, filters for A>G edit. If -b C was provided, filters for C>T edit.`\
    --filter-window --edit-start-pos 0 --edit-end-pos 19   `# Filter based on editing window in spacer position within reporter.`\
    --filter-allele-proportion 0.1 --filter-sample-proportion 0.3 `#Filter based on allele proportion larger than 0.1 in at least 0.3 (30%) of the control samples.` \
    --translate --translate-genes-list $working_dir/$gene_symbols_file

####################################################################################################
### Bean run

bean run survival tiling ${working_dir}/${output_dir}/${screen_id}_Filtered.h5ad \
    -o ${output_dir} \
    --control-condition $control_condition \
    --fit-negctrl \
    --negctrl-col target_group \
    --negctrl-col-value NegCtrl #\


mv output.log $output_dir/output_successfull.log
mv error.log $output_dir/error_successfull.log