# groupme-shell
stupid simple shell wrappers to hook into groupme

# Installation 
```bash
$ ./install
```

# Workflow
## Auth
```bash
$ groupme-login
```
and provide an access token from [groupme](https://dev.groupme.com/).

You can always logout with ```groupme-logout```. **Note** there is nothing clever here. The 
token is stored in plaintext in ```$HOME/.groupme-shell```.

## Groups
```bash
$ groupme-join
....
$ groupme-leave
```

Here we check for groups you are currently part of, give you a simple prompt, and allow you to choose. This choice is sticky and is persited in ```~/.groupme-shell```.

## Messaging
```bash
$ groupme-listen
person [time]> message
..
```

Listening causes the current shell to poll groupme for messages. To message back, open another terminal
```bash
$ groupme-message
hey everyone!
```
