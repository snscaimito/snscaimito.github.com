#!/bin/bash
docker run --volume="$PWD/content:/srv/jekyll" -p "4000:4000" -it jekyll/jekyll jekyll serve
# docker compose up
