# github-cli
A CLI container for [Github CLI](https://github.com/cli/cli).

With this container, you can avoid having to build and install the Github CLI yourself, and you can easily experiment with different versions of the tool if you need to.

### So, what is a CLI container?

CLI containers wrap a single command line utility, allowing the user to transparently use it in place installing the CLI utility. The container started with an alias or a script that.

## Using the container

1. Copy `gh` to `$HOME/.local/bin`
2. Make sure it is executable by running `chmod +x $HOME/.local/bin/gh`
3. Start an `ssh-agent` and add the ssh key you use for Github. If in doubt, just run `gh` to get more info.
4. Run `gh auth login` to generate an authentication token 
5. You can now run any other `gh` command. Try
```
gh repo view cli/cli
gh repo clone cli/cli
```

If you wan't to use the `ssh` protocol, gh needs access to you ssh key. The container mounts the currently running 

## Auth options

The Github CLI requres a few things to work:
- An access token is needed to ensure you have the necessary permissions in Github
- Since you should be using `ssh` when accessing Github, `gh` needs access to you ssh key.

The authentication token and other relevant configuration will be stored in `$HOME/.config/gh` on your local machine
and is mounted into the container at runtime. This ensures that auth and config is persisted between runs.

The SSH key is made available to the container by making the ssh-agent on the local machine available inside the container.
This way we avoid storing the private ssh key inside the container at any point. Much secure. Wow!

For detailed information on the pros, cons and pitfalls of how to properly use the ssh-agent, I recommend you read
[The pitfalls of using ssh-agent, or how to use an agent safely](http://rabexc.org/posts/pitfalls-of-ssh-agents)

### Login with a web browser

The `gh auth login` guide will allow you to `Login with a web browser`. This is absolutely the easiest option.
The only issue is that opening the browser automatically will fail. To get around that, just copy the URL given
in the guide text, and copy it into a brower manually. Then copy the onetime token and paste it in the page you
just navigated to. The authentication will be completed and relevant connection info will be added to `$HOME/.config/gh`
on you local machine.

### Paste an authentication token

An alternative to loggin in with a browser is to manually create an authentication token.
`gh` will describe what you need to do create a token on [github.com](https://github.com/settings/tokens).
The token needs to have at least the `repo` and `read:org` scopes.

When you have the token, paste it into the wizard to persist it.


## Building

```
docker build . -t michaelin/github-cli
```
This will create an image from the head of the `trunk` branch of the [Github CLI repo](https://github.com/cli/cli.git).

To build a specific tag or branch, you need to pass the CLI_VERSION build arg:

```
docker build --build-arg CLI_VERSION=v0.9.0 . -t michaelin/github-cli:v0.9.0
```