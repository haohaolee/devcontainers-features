
# Create Remote User (create-remote-user)

A to assert the configured remote user exists in the container

## Example Usage

```json
"features": {
    "ghcr.io/haohaolee/devcontainers-features/create-remote-user:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| create | Create the user if it doesn't exist | boolean | true |
| addToSudo | Add the user to sudo group and configure sudo access | boolean | true |
| installSudo | Install sudo if it is not yet installed | boolean | true |
| runSudoWithoutPassword | When addToSudo is true, allow the user to run sudo without password | boolean | false |

## OS Support

This feature currently only supports Debian based containers (where APT is used as package manager).

`bash` is required to run the install script.

## Remarks

When `create` is set to `true` and the user does not exist, the user is created and given a password that equals its name.

:warning:
If the user already exists, the password is not changed.
If no password is set, it is not possible to use `sudo`.

## Security Considerations

When `runSudoWithoutPassword` is set to `true`, the user will be able to execute any command with sudo privileges without entering a password. This is convenient for development environments but should be used with caution in production-like environments.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/haohaolee/devcontainers-features/blob/main/src/create-remote-user/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
