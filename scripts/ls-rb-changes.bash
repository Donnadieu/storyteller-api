# List all the changed Ruby files in the current git repository
git ls-files -m | xargs ls -1 2>/dev/null | grep '\.rb$'
