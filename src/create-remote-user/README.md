# Create Remote User (create-remote-user)

A feature to assert the configured remote user exists in the container

## Example Usage

### Basic Usage (Default Configuration)
```json
"features": {
    "ghcr.io/haohaolee/devcontainers-features/create-remote-user:0": {}
}
```

### Passwordless Sudo Configuration
```json
"features": {
    "ghcr.io/haohaolee/devcontainers-features/create-remote-user:0": {
        "addToSudo": true,
        "runSudoWithoutPassword": true
    }
}
```

### Disable Sudo Access
```json
"features": {
    "ghcr.io/haohaolee/devcontainers-features/create-remote-user:0": {
        "addToSudo": false,
        "installSudo": false
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| create | Create the user if it doesn't exist | boolean | true |
| addToSudo | Add the user to sudo group and configure sudo access | boolean | true |
| installSudo | Install sudo if it is not yet installed | boolean | true |
| runSudoWithoutPassword | When addToSudo is true, allow the user to run sudo without password | boolean | false |

## Sudo Configuration

This feature provides precise control over sudo access for the remote user:

- **`addToSudo=true, runSudoWithoutPassword=false`** (default): User has sudo access but must enter password
- **`addToSudo=true, runSudoWithoutPassword=true`**: User can run sudo without password (NOPASSWD configuration)
- **`addToSudo=false`**: User has no sudo access

The feature creates dedicated sudoers configuration files in `/etc/sudoers.d/` for precise control rather than relying solely on group membership.

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

The passwordless sudo configuration is implemented by creating a file in `/etc/sudoers.d/` with the appropriate permissions and validation.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/haohaolee/devcontainers-features/blob/main/src/create-remote-user/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._