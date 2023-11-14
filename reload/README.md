# Reload
## Goal
In this part, modify `A.hi` in `lib/a.rb` could make the text changed in the console.

## Crucial Concern
1. using monkey patch deal with `String#camelize` and `String#constantize`
2. remove const and load again
