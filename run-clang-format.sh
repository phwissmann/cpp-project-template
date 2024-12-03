#!/bin/bash 
cd src
SRC_DIRS=(example)

# Format in place
# find ${SRC_DIRS[@]}  -name "*.h" -print0 -or -name "*.cpp" -print0 -or -name "*.inl" -print0 | xargs -0 -I {} clang-format-18 -i {} --verbose

# Check formatting
find ${SRC_DIRS[@]} \( \( -name \*.cpp -o -name \*.h \) -a ! -iname \*soap\* \) -print0 | xargs -0 -n 1 clang-format-18 --Werror -n --verbose
