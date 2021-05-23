#!/bin/sh
cd /app/docs
bundle install
bundle exec jekyll serve --drafts -H 0.0.0.0 -w
