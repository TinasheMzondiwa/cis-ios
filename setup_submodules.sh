#!/bin/sh

# Initialize and update the submodule
git submodule update --init --recursive

# Configure sparse checkout to only fetch the "v2" directory
git -C Shared/Resources sparse-checkout set --no-cone "v2/*"

echo "Submodule Shared/Resources configured to only checkout v2/"
