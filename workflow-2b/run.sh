#!/bin/bash
set -e

echo -n  "Checking this is Linux..."
if [[ `uname` == Linux ]]; then
  echo 'ok'
else
  echo 'no'
  echo "This is for Docker on Linux only!"
  echo "User mapping is not needed for Docker for Mac"
  exit 1
fi

echo docker pull continuumio/anaconda3
docker pull continuumio/anaconda3

echo docker build -t pybay-workflow-2b .
docker build -t pybay-workflow-2b .

echo "Entering docker shell, type \"exit\" to return back to host shell"
echo docker run -it --rm --userns=host -u `id -u`:`id -g` \\
echo     -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro \\
echo     -v `pwd`:/host pybay-workflow-2b:latest /bin/bash
docker run -it --rm --userns=host -u `id -u`:`id -g` \
    -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro \
    -v `pwd`:/host pybay-workflow-2b:latest /bin/bash
