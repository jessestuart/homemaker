## Homemaker

`homemaker` is a tool composing [Vagrant][vagrant-url], [Packer][packer-url],
and [Ansible][ansible-url] to automate the creation of machine environments
that "feel like home".

<p align="center">
  <img src="http://jstu.art/oWBB/980x.gif" />
</p>

You know that feeling of spinning up a box, only to find yourself on the verge
of self-defenestration when none of your aliases work; none of the right
dependencies are installed; and what should be a quick task turns into a wasted
morning. Nobody wants that.

<p align="center">
  <img src="http://jstu.art/oWQD/tenor.gif">
</p>

Homemaker is an opinionated devbox-generator for everyday use, whether locally
(i.e., via a Vagrant box) or cloud-based (e.g., by using a Packer builder for
AWS or Digital Ocean). Homemaker was created largely because I got sick of
spinning up boxes and seeing some variation of this:

```sh
[vagrant@homemaker-1514256437]~% la
zsh: command not found: la
[vagrant@homemaker-1514256437]~% dk ps
zsh: command not found: dk
```

TL;DR: `homemaker` is a way to automate the creation of machines that feel like
home — all the libraries, dependencies, and (most importantly) dotfiles that
you've grown to know and love.

### Disclaimer

Homemaker is still a work in progress. Shortcomings I plan on improving upon:

* Support dotfile management systems beside Thoughtbot's RCM.
* Update roles to be more distro-agnostic — this is currently somewhat tightly
  coupled to CentOS, but it would be super to be able to spin up environments
  in any major distro (Debian and friends, Alpine, etc).

[ansible-url]: https://github.com/ansible/ansible
[packer-url]: https://github.com/hashicorp/packer
[vagrant-url]: https://github.com/hashicorp/vagrant
