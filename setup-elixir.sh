#!/bin/bash
export PATH=${HOME}/.mix:${PATH}
git clone https://github.com/pprzetacznik/IElixir.git
cd IElixir
mix local.hex --force
mix local.rebar --force
mix deps.get
mix test
MIX_ENV=prod mix compile
./install_script.sh