## Homemaker

[![SemaphoreCI Build Status][semaphoreci-badge]][semaphoreci-link]

`homemaker` is a tool composing [Vagrant][vagrant-url], [Packer][packer-url],
and [Ansible][ansible-url] to automate the creation of machine environments
that "feel like home".

<p align="center">
  <img src="http://jstu.art/oWBB/980x.gif" />
</p>

You know that feeling -- you spin up a box, only to find yourself on the verge
of self-defenestration when none of your aliases work; none of the right
dependencies are installed; and what should be a quick task turns into a wasted
morning. Nobody wants that.

<p align="center">
  <img src="http://jstu.art/oWQD/tenor.gif">
</p>

Homemaker is an opinionated devbox-generator for everyday use, whether locally
(i.e., via a Vagrant box) or cloud-based (e.g., by using a Packer builder for
AWS, Digital Ocean, Vultr, etc.). Homemaker was created largely because I got
sick of spinning up boxes and seeing some variation of this:

```sh
[vagrant@homemaker-1514256437]~%
=> # Cool! I'm in! Let me just list what's in the current directory:
[vagrant@homemaker-1514256437]~% la
=> zsh: command not found: la
=> # Oh right, this is a fresh box. Well at least it has Docker installed,
=> # right? I'll just run this...
[vagrant@homemaker-1514256437]~% dk ps
zsh: command not found: dk
=> # Well that was dumb. If only I had a way to automatically load a fully
=> # provisioned box **with all my custom dotfiles** I've so carefully curated
=> # over the years... Now that would be the bee's knees.
```

TL;DR: `homemaker` provides a way to automate the creation of machines that
feel like home -- none of the bloat of a full desktop OS, just the dependencies
& libraries you need to get to get cookin', and (most importantly), your
trusty, dependable dotfiles.

### Usage

`homemaker` supports several methods of execution, depending on your needs.

#### Local VM

If all you need is a isolated, disposable development environment, then using
the provided Vagrantfile to run `homemaker` as a local VM is a great place to
start.

* =============================================================
* TODO: Add Makefile to install necessary vagrant plugins, etc.
* =============================================================

```sh
git clone https://github.com/jessestuart/homemaker
cd homemaker
vagrant up
```

NOTE: This assumes that you have the `vagrant` CLI tool installed on the host
machine. If not, consult the Vagrant [installation docs][vagrant-installation]
to obtain the installation binary for your OS. Note that Hashicorp strongly
advises against using package managers:

> "Typically these packages are missing dependencies or include very outdated
> versions of Vagrant. [...] Please use the official installers on the
> downloads page."
> Anecdotally, I've never had issues on macOS with simply running
> `cask install vagrant`, although YMMV.

#### Cloud-based machine images

`homemaker` can also be used to build identical machine images for one of the
several major cloud compute providers, in case you want to spin up an
environment -- whether as a simple remote sandbox, or as the foundation for
a hardened production-ready server -- using Packer builders. Services currently
supported are:

* [x] AWS
* [x] Digital Ocean
* [x] Vultr

Support for other services, including Linode and GCE, is on the roadmap.

* ==============================================================
* TODO: Add instructions for building and running Packer images.
* ==============================================================

### Disclaimer

Homemaker is still a work in progress. Shortcomings I plan on improving upon:

* Support dotfile management systems beside Thoughtbot's RCM.
* Update roles to be distro-agnostic — `homemaker` currently only supports
  CentOS, but it would be super to be able to spin up environments
  in any major distro (Debian and friends, Alpine, etc). I've already make some
  preliminary progress on this front. PR's always welcome and encouraged.

[ansible-url]: https://github.com/ansible/ansible
[packer-url]: https://github.com/hashicorp/packer
[vagrant-url]: https://github.com/hashicorp/vagrant
[vagrant-installation]: https://www.vagrantup.com/downloads.html
[semaphoreci-badge]: https://semaphoreci.com/api/v1/jesses/homemaker/branches/jesse-add_circleci/badge.svg
[semaphoreci-link]: https://semaphoreci.com/jesses/homemaker
