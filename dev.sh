#!/bin/sh
set -e

echo "Creating dev environment in ./venv..."

python=python3
if [ "$#" -eq 1 ]; then
    python=$1
fi
version_number=$($python --version)
if [[ "$version_number" != "Python 3.9"* ]]; then
  echo -e '\033[0;31mWarning! This script is initilizing a virtualenv with $version_number instead of Python 3.9. Python 3.9 is the supported development version of qtile. You can pass an argument to this script for what python binary to use, e.g. "./dev.sh python3.9".\033[0m'
  read -p "Do you wish to continue anyway? " yn
  case $yn in
    [Yy]* ) make install; break;;
    [Nn]* ) exit;;
    * ) echo "Did not understand answer, exiting";;
  esac
fi
set -x

${python} -m venv venv
. venv/bin/activate
pip install -U pip setuptools wheel

# https://github.com/qtile/qtile/issues/994#issuecomment-497984551
echo "Installing xcffib then cairocffi..."
pip install 'xcffib >= 0.10.1' && pip install --no-cache-dir 'cairocffi >= 0.9.0'

echo "Installing other required packages..."
pip install -r requirements.txt
pip install -r requirements-dev.txt

echo ""
echo "  * Created virtualenv environment in ./venv."
echo "  * Installed all dependencies into the virtualenv."
echo "  * You can now activate the $(python3 --version) virtualenv with this command: \`. venv/bin/activate\`"
