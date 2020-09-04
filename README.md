# [Deprecated] - moved to https://github.com/armando-fandango/ezai_env
# this version is not being maintained anymore
# ezai-docker
## Description
Docker container and conda python virtual environment creation for doing AI

## Pre-requisites
- Linux: Python is Installed
- Windows: Python is installed, preferably miniconda.

## Usage

### To create conda environment:

- modify `ezai-conda-req.txt` as needed
- modify `ezai-pip-req.txt` as needed
- for linux: execute `ezai-conda-create.sh --venv <location-of-env>  --python-ver <python-version>`
    - for windows: execute `ezai-conda-create.ps1 -venv <location-of-env>  -python-ver <python-version>`
    - `<location-of-env>`: Default is `/opt/conda/envs/ezai` on linux and `C:/Miniconda3/envs/ezai` on windows
    - `<python-version>`: Defalult is `3.7`
    - You can supply your own `requirements.txt` files with `--piptxt` and `--condatxt`.
- activate the environment with `conda activate <location-of-env>`
- test the tensorflow and pytroch GPU with `pytest -p no:warnings -vv`

### to create a docker environment with conda:

Note: This version maps `$home` directory and /mnt directory on host to docker container so be careful with modifying anything inside the container, it will also be modified on the host

- modify `.env` file as needed
- execute `./run`
    - creates the image if not present
    - starts the container if not started
    - enters the container
- I generally create an alias in bash to run the notebooks from the container quickly:
`alias eznb='conda activate ezai && jupyter notebook --ip=* --no-browser'`
    
## TODO:

- Give option to create fully isolated container
- Give option to select which libraries to install
- add/enable more libraries
- make separate dockerfile for Sumo and create only if asked from the run
    
