#!/bin/bash

# Debug, echo every command
#set -x

JS_RUNTIME_ENV_PREFIX="${JS_RUNTIME_ENV_PREFIX:-JS_RUNTIME_}"

# Each bundle is generated with a unique hash name to bust browser cache.
# Use shell `*` globbing to fuzzy match.
# create-react-app v2 with Webpack v4 splits the bundle, so process all *.js files.
js_bundles="${JS_RUNTIME_TARGET_BUNDLE:-/app/build/static/js/*.js}"
# Get exact filenames.
js_bundle_filenames=`ls $js_bundles`

if [ ! "$?" = 0 ]
then
  echo "Error injecting runtime env: bundle not found '$js_bundles'."
fi

# Fail immediately on non-zero exit code.
set -e

for js_bundle_filename in $js_bundle_filenames
do
  echo "Injecting runtime env into $js_bundle_filename (from .profile.d/inject_react_app_env.sh)"

  # Render runtime env vars into bundle.
  ruby -E utf-8:utf-8 \
   -r /app/.heroku-react-app-runtime-env/injectable_env.rb \
   -e "InjectableEnv.replace('$js_bundle_filename')"
done