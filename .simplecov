# kettle-jem:freeze
# To retain chunks of comments & code during flag_shih_tzu templating:
# Wrap custom sections with freeze markers (e.g., as above and below this comment chunk).
# flag_shih_tzu will then preserve content between those markers across template runs.
# kettle-jem:unfreeze

require "kettle-soup-cover"
require "kettle/soup/cover/config"

# Minimum coverage thresholds are set by kettle-soup-cover.
# They are controlled by ENV variables loaded by `mise` from `mise.toml`
# (with optional machine-local overrides in `.env.local`).
# If the values for minimum coverage need to change, they should be changed both there,
#   and in 2 places in .github/workflows/coverage.yml.
SimpleCov.start do
  track_files "lib/**/*.rb"
  track_files "lib/**/*.rake"
  track_files "exe/*.rb"
end
