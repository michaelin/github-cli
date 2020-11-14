# github-cli
A CLI container for [Github CLI](https://github.com/cli/cli).

The image can be found on (https://hub.docker.com/r/michaelin/github-cli)

With this container, you can avoid having to build and install the Github CLI yourself, and you can easily experiment with different versions of the tool if you need to.

### So, what is a CLI container?

CLI containers are Docker containers, that wrap a single command line utility. It allows you to transparently use it in place installing the CLI utility. You avoid installing any dependencies (other than Docker) and can easily switch the tool version by
simply running a different version of the container.

The container is started with a wrapper script that you put on the path. The wrapper script has the same name as the tool you want
to run, and passes any arguments on to the tool in the container. This way, it will be transparent for the user, that the tool
is running in Docker.

It is also possible to simply create an alias with the Docker command, instead of using a wrapper script. But using a script is more flexible, since you can use it inside other scripts (just as with the original tool). This is not an option with aliases. 

## Run the container with a wrapper script

1. Copy `gh` to a directory on your path, e.g. `$HOME/.local/bin`
1. Make sure it is executable by running `chmod +x $HOME/.local/bin/gh`
1. Run `gh auth login` to generate an authentication token and confiugre the tool.
1. You can now run any other `gh` command. You can try:
```
gh repo view cli/cli
gh repo clone cli/cli
```

## Configuration

The Github CLI requres a few things to work:
- An access token is needed to ensure you have the necessary permissions in Github
- If you're using `ssh` for accessing Github, `gh` will need access to you ssh key.

### Authentication token
The `gh auth login` command will guide you through the process of generating an authentication token. 
The token and other relevant configuration will be stored in `$HOME/.config/gh` on your local machine.
This ensures that auth and config is persisted between runs, and will be mounted into the container at runtime. 

### SSH key
The SSH key is made available to the container through a local SSH agent.
By using the SSH agent we avoid storing the private ssh key inside the container at any point. Much secure. Wow!

1. Start the SSH agent:
`eval $(ssh-agent -s)`
1. Add you ssh key to the agent:
`ssh-add /path/to/keyfile`

When the container is run, the wrapper will discover the currently active ssh-agent and make it available for use inside the container.

For detailed information on the pros, cons and pitfalls of how to properly use the ssh-agent, I recommend you read
[The pitfalls of using ssh-agent, or how to use an agent safely](http://rabexc.org/posts/pitfalls-of-ssh-agents)

### Login with a web browser

The `gh auth login` guide will allow you to `Login with a web browser`. This is absolutely the easiest option.
The only issue is that opening the browser automatically will fail because there is no browser inside the container.
To get around that, just copy the URL given in the guide text, and copy it into a brower manually.
Then copy the onetime token and paste it in the page you just navigated to.
The authentication will be completed and relevant connection info will be added to `$HOME/.config/gh`
on you local machine.

### Paste an authentication token

An alternative to loggin in with a browser is to manually create an authentication token.
`gh` will describe what you need to do create a token on [github.com](https://github.com/settings/tokens).
The token needs to have at least the `repo` and `read:org` scopes.

When you have the token, paste it into the wizard to persist it.


## Building locally

```
docker build . -t michaelin/github-cli
```
This will create an image from the head of the `trunk` branch of the [Github CLI repo](https://github.com/cli/cli.git).

To build a specific tag or branch, you need to pass the CLI_VERSION build arg:

```
docker build --build-arg CLI_VERSION=v1.2.1 . -t michaelin/github-cli
```