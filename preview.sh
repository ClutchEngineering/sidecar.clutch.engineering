(trap 'kill 0' SIGINT; while sleep 0.1; do find Sources/gensite -type f -name "*.md" -o -name "*.swift" | entr -d swift run gensite; done & python3 -m http.server -d site/ 8090 & npx tailwindcss -i tailwind.css -o ./site/css/main.css --watch)
