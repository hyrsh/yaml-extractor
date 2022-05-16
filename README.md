# Simple YAML extractor script
I need this kind of script sometimes and maybe some other human will see its usability.

# Usage
./yaml-extractor <FILE>

# Result
All YAML blocks (separated by "---") get isolated and saved in a new directory (./extracted) with their KIND and NAME.
Since this is specific to K8S I used "kind:" and "name:" first appearances (head -1) but you can change it, if you need/want.
