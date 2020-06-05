# github-cli
cli-container for github-cli
See https://github.com/cli/cli

## Building
Clone the repo and build the container with like this
```
docker build . -t michaelin/gh-cli
```

## Prepare cli container
Create a new file called `gh` somewhere in your path and make it executable
```
mkdir -p $HOME/.local/bin/
touch $HOME/.local/bin/gh
sudo chmod +x $HOME/.local/bin/gh
```

Add the following to the file
```
docker run -it --rm \
    --user $(id -u):$(id -g) \
    -v $PWD:/git -w /git \
    -e GITHUB_TOKEN \
    michaelin/gh-cli
```

`gh` requires a GITHUB_TOKEN to function. There are currently problems with doing this automatically from headless systems, so you'll have to [generate a personal access token](https://github.com/settings/tokens) yourself. The token needs to have the `repo` and `read:org` scopes.

Make sure the token is available in the GITHUB_TOKEN environment variable.

You should now be able to run `gh` from anywhere you like.