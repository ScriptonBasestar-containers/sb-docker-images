#!/bin/sh
set -e

/bin/sh /install/install.sh

# echo "===================="
# echo ls /install
# ls /install
# echo "===================="
# echo ls /install/init.d
# ls /install/init.d
# echo "===================="
for f in /install/init.d/*.sh; do  # or wget-*.sh instead of *.sh
  # echo "===================="
  # echo "$f"
  sh "$f" -H 
done

exec "$@"
