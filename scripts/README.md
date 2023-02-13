# scripts

## Shell Scripts

- shell scripts are essentially executable programs and shell builtins
- the previous command's exit status can be passed to the next command
- zero values are interpreted as successful, anything otherwise is a failure
- a script can read the variable `$?` to find the last known exit code

## Exit Codes

```bash
echo $?
mkdir /etc
echo $?
mkdir /etc || cd /etc
mkdir -p ~/Documents && cd ~/Documents
```

An exit code of 0 is a success.
