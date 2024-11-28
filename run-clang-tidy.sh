#!/bin/bash 

# set up wrapper around clang-tidy to use cache
export CTCACHE_DIR=$(dirname $(realpath ${0}))/.ctcache
export CTCACHE_LOCAL=1
WRAPPER=$(dirname $(realpath ${0}))/clang-tidy-wrapper

# invocke clang tidy through python runner script
./run-clang-tidy.py -p ./build -clang-tidy-binary=$WRAPPER  -clang-apply-replacements-binary=clang-apply-replacements-18 -j 8  \
  -source-filter=".*/src/.*"\
  -config-file="./src/.clang-tidy"\
  -fix \
  -use-color \
  -warnings-as-errors="*" \