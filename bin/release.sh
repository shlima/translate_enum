#!/usr/bin/env bash

rm ./*.gem
gem build translate_enum.gemspec
gem push translate_enum-*
