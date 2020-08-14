#!/usr/bin/env bash

# add -k if ssl_verify needs to be set to false
pkgs="jupyter notebook jupyter_contrib_nbextensions jupyter_nbextensions_configurator"

#TODO: probably change this default to ~/envs once docker is implemented
venv=${venv:-$/opt/conda/envs/ezai}
py_ver=${py_ver:-3.7}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
   fi

  shift
done

# We imort conda command as sometimes it doesnt work otherwise
if [[ "${OSTYPE}" == 'cygwin' ]]
then
  export SHELLOPTS # should be after or before set ?
  set -o igncr # execute it manually for now it doesnt work
  source /cygdrive/c/Miniconda3/etc/profile.d/conda.sh
else
  source $(conda info --base)/etc/profile.d/conda.sh
fi

opts=" --strict-channel-priority"
channels=" -c conda-forge "
conda activate $venv || \
    (echo "${venv} doesnt exist - creating now with python ${py_ver}..." && \
    conda create -y  -p $venv $channels $opts python=$py_ver $pkgs && \
    conda activate $venv && \
    conda config --env --prepend channels conda-forge && \
    conda config --env --set channel_priority strict && \
    conda config --env --remove channels defaults && \
    conda config --set auto_activate_base false && \
    jupyter nbextension enable code_prettify/code_prettify && \
    jupyter nbextension enable toc2/main)
    #jupyter nbextension enable ipyparallel && \
conda deactivate $VENV

channels+=" -c pytorch "
channels+=" -c fastai "

conda activate $venv && \
    conda install -y -p $venv $channels $opts --file ./ezai-conda-req.txt --prune &&\
    # install pip with no-deps so it doesnt mess up conda installed versions
    pip install --no-deps --use-feature 2020-resolver -r ./ezai-pip-req.txt


