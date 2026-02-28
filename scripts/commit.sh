#!/bin/bash

echo "Conventional Commit Helper"
echo "========================="
echo ""
echo "Types:"
echo "  feat     - A new feature"
echo "  fix      - A bug fix"
echo "  docs     - Documentation only changes"
echo "  style    - Changes that don't affect code meaning"
echo "  refactor - Code change that neither fixes nor adds"
echo "  perf     - A code change that improves performance"
echo "  test     - Adding or correcting tests"
echo "  build    - Changes to build system or dependencies"
echo "  ci       - Changes to CI configuration"
echo "  chore    - Other changes that don't modify src"
echo ""

read -p "Type: " type
read -p "Scope (optional): " scope
read -p "Short description: " description
read -p "Long description (optional): " body
read -p "Breaking changes? (y/N): " breaking

if [ -z "$description" ]; then
    echo "Error: Description is required"
    exit 1
fi

scope_part=""
if [ -n "$scope" ]; then
    scope_part="($scope)"
fi

breaking_part=""
if [ "$breaking" = "y" ] || [ "$breaking" = "Y" ]; then
    breaking_part="BREAKING CHANGE: "
fi

commit_msg="$type$scope_part: $description"
if [ -n "$body" ] || [ "$breaking" = "y" ] || [ "$breaking" = "Y" ]; then
    commit_msg="$commit_msg"$'\n\n'"$breaking_part$body"
fi

echo ""
echo "Commit message:"
echo "$commit_msg"
echo ""

read -p "Create commit? (y/N): " confirm

if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
    git commit -m "$commit_msg"
    echo "Commit created!"
else
    echo "Cancelled"
fi
