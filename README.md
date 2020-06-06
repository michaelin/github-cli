# github-cli
A CLI container for [Github CLI](https://github.com/cli/cli).

With this container, you can avoid having to build and install the Github CLI yourself, and you can easily experiment with different versions of the tool if you need to.

### So, what is a CLI container?

CLI containers wrap a single command line utility, allowing the user to transparently use it in place installing the CLI utility. The container started with an alias or a script that.

## Github Personal Access Token

`gh` requires a GITHUB_TOKEN to function. There are currently problems with doing this automatically from headless systems, so you'll have to [generate a personal access token](https://github.com/settings/tokens) yourself. The token needs to have the `repo` and `read:org` scopes.

Make sure the token is available in the GITHUB_TOKEN environment variable.

## Running the container
The following command is used to run the container
```
docker run -it --rm \
    --user $(id -u):$(id -g) \
    -v $PWD:/git -w /git \
    -e GITHUB_TOKEN \
    michaelin/github-cli
```

This is the equivalent of running the `gh` command without parameters. Add `gh` required parameters at the end of the commmand.

Now, that is neither simple or transparent to the user. Instead, you can create an alias to wrap it all. Add the following to .bashrc or .bash_aliases

```
alias gh='docker run -it --rm \
    --user $(id -u):$(id -g) \
    -v $PWD:/git -w /git \
    -e GITHUB_TOKEN \
    michaelin/github-cli \
    $*'
```

And you´re now good to go:
```
gh repo view -R cli/cli
gh repo checkout https://github.com/cli/cli.git
```

## Building

```
docker build . -t michaelin/github-cli
```
This will create an image from the head of the `trunk` branch of the [Github CLI repo](https://github.com/cli/cli.git).

To build a specific tag or branch, you need to pass the CLI_VERSION build arg:

```
docker build --build-arg CLI_VERSION=v0.9.0 . -t michaelin/github-cli:v0.9.0
```