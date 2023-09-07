#!/bin/bash

## Job name and files
#SBATCH --job-name=test_code_jun_li_width_detection
## OUTPUT AND ERROR
#SBATCH -o out_eutectics%j.out
#SBATCH -e err_eutectics%j.err

## Initial working directory
##SBATCH -D "." 

## specify your mail address (send feedback when job is done)
##SBATCH --mail-type=begin  				          # send email when process begins...
##SBATCH --mail-type=end    				          # ...and when it ends...
##SBATCH --mail-type=fail   		 	             # ...or when it fails.
##SBATCH --mail-user=lukas.berners@rwth-aachen.de	 # send notifications to this emai REPLACE WITH YOUR EMAIL

## Setup of execution environment 
#SBATCH --export=NONE

## account and partition selection
####SBATCH --partition='c18g' #####'c18g'
####SBATCH --gres=gpu:1
#SBATCH --account=rwth1308

##Memory need / node
#SBATCH --mem=128G

#number of threads
#SBATCH --cpus-per-task=1

## OPTIONAL
## set max. file size to 500Gbyte per file
##SBATCH -F 500000000

## execution time in [hours]:[minutes]:[seconds]
## recommended: less than 24:00
#SBATCH --time=00:30:00 ###36
#####SBATCH --time=1-00:00:00

############################################### 
###############################################
########## END OF SLURM INSTRUCTION ###########
##!!! DO NOT PLACE SHELL VARIABLES ABOVE!!!####
###############################################
###############################################

## Optional lines to remove all modules loaded and load the one disired
## Not need to use them if you use the default modules
## In the case the code has been compiled with the intel2016, change the following line accordingly 
#module purge; module load DEVELOP DEPRECATED
##module load intel
##module load intelmpi/2018.3.222
##export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/itv/compile_centos7/lib/sundials/2.7.0_intel19.0_intelmpi_2018_mkl/Install_DIR/lib/
##module switch intelmpi/2018 openmpi/1.10.6
##module switch intel/19.0 intel/16.0

#### *** start of job script ***
# adniconda3 4.5.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!

### Processor affinity options
### Processor pinning
#export I_MPI_PIN=1
#export I_MPI_PIN_DOMAIN=core
##export PYTHONPATH=$PYTHONPATH:/home/mr189568/miniconda3/MyLibraries/dlipr
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/mz071159/yolov5/venv/
source /home/mz071159/miniconda3/bin/activate base

## #executable name (e.g. arts_cf)
### exe="arts"

### executable arguments
### args="tripleFlame.input"

date
### ##$MPIEXEC $FLAGS_MPI_BATCH $I_MPI_PIN $I_MPI_PIN_DOMAIN ./$exe $args
### $MPIEXEC $FLAGS_MPI_BATCH ./$exe $args

###srun python train.py --img 1600 --batch 4 --epochs 2500 --data '../data.yaml' --cfg ./models/custom_yolov5s.yaml --weights '' --name yolov5s_results  --cache
###srun python train.py --img 2000 --batch 4 --epochs 2500 --data '../data.yaml' --cfg ./models/custom_yolov5s.yaml --weights '' --name yolov5s_results  --cache
###srun python detectbyehsan.py --weights /home/mr189568/venv6/new1/yolov5/runs/exp12_yolov5s_results/weights/best.pt --img 7750 --conf 0.01 --source /home/mr189568/venv6/new1/images,15500,7750/left_bottom_corner/x3-Aligned_15500*15500_Cropped_7750*7750_Cropped_left_bottom_corner.png --save-txt

srun python3 euler_numbers.py


####srun test.py
date


