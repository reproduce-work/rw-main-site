# Define the function to strip YAML front matter
strip_yaml() {
    sed '/^---$/,/^---$/d' $1
}

# Strip YAML and add title for the first file
echo "# reproduce.work" > cli-readme.qmd
strip_yaml index.qmd >> cli-readme.qmd

# Add a newline for separation
echo -e "\n\n" >> cli-readme.qmd

# Strip YAML and add title for the second file
echo "# Getting Started" >> cli-readme.qmd
strip_yaml docs/getting-started.qmd >> cli-readme.qmd

# oneliner that doesn't strip YAML
#(echo "# reproduce.work"; cat index.qmd; echo -e "\n\n# Getting Started"; cat docs/getting-started.qmd) > cli-readme.qmd

echo "Rendered cli-readme.md"