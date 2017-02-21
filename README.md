# nginx with ALPN support for Enterprise Linux

This project contains a set of scripts and dockerfiles (recipes) to build, sign
and push to PackageCloud.io a distribution of nginx with Application-Layer
Protocol Negotiation support for RedHat Enterprise Linux and CentOS as a result
of bundling together a more recent version (>= 1.0.2) of OpenSSL, instead of
using the default distribution provided old version of OpenSSL.

The way these packages are built enables use of the newer OpenSSL just for
nginx, without messing with the system-shared libraries. It's a dropin
replacement of both the EPEL and official nginx.org build of nginx.

See the following blogpost for the installation procedure of my yum repository:
https://bcdonadio.com/2016/nginx-alpn-el/

## Versions
* nginx: 1.11.10
* openssl: 1.1.0e

## Supported distributions
* RedHat Enterprise Linux (RHEL) 6
* RedHat Enterprise Linux (RHEL) 7
* CentOS 6
* CentOS 7

## Building
### Dependencies
Ensure you have the following in your building machine:
* recent version of Docker
* rubygems
* rpm-sign

In Fedora, you can install these with:
```
# yum install docker rubygems rpm-sign
```

Then, if you intend to push the files to Packagecloud.io, install it with:
```
# gem install package_cloud
```

### Scripts
#### build.sh
This script creates a container for each `$VERSION` (space separated) of a
`$DIST` (single distribution supported currently) listed on the `common.sh`
script, naming it according to the `$REPO` parameter, and executes the
according dockerfile in the `recipes` folder (simple concatenation of `$DIST`,
`$VERSION` and `.dockerfile`).

The resulting artifacts are copied to the host machine on the `build` folder.

#### sign.sh
This script signs with your GPG key listed in your `~/.rpmmacros` file all rpm
packages underneath the `build` folder.

A valid `~/.rpmmacros` looks like the following:
```
%_gpg_name Bernardo Donadio (https://www.bcdonadio.com/) <bcdonadio@bcdonadio.com>
%__gpg /usr/bin/gpg2
```

Obviously, you need to have the secret-key of the identity listed in the
`%_gpg_name` directive in your gpg keyring.

Caution: gpg and gpg2 use different keyrings, and both can be installed at the
same time.

#### push.sh
This script pushes every rpm file underneath the `build` folder to
Packagecloud.io, verifying their signatures are valid in the processes. If a
package isn't signed with a valid signature, it aborts the process.

The repository used is the one listed inside the `common.sh` script, in the
`$REPO` directive.

In the first run, the `package_cloud` package will asks your user and password
for the service. Also obviously, you need to have push privileges to the
repository.
