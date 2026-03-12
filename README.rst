Wolph's Dotfiles
------------------------------------------------------------------------------

Probably too specific for my needs for people to use out of the box, but there
might be some nice things in here which you will like.

Have a look around, take what you need and please drop me a line if you have
any questions or simply like the scripts/settings/etc.

Cheers :)

Installation
==============================================================================

If you are brave enough to give it a try, the install is fairly simple:

::

    git clone git@github.com:berjan/dotfiles.git
    cd dotfiles
    ./install.sh

Don't worry, it won't overwrite anything and only symlink the files to this
location if they don't exist yet. Trying is perfectly safe.

Uninstallation
==============================================================================

If you don't like it anymore, there's always the uninstall script.

::

    cd dotfiles
    ./uninstall.sh

TMUX + MOSH + GHOSTTY CLIPBOARD
==============================================================================

This setup supports copying from remote tmux sessions to the local macOS
clipboard (Ghostty) via OSC 52.

Current behavior and notes:

- Direct OSC 52 works over ``mosh``.
- tmux's default clipboard path can fail over ``mosh`` in some cases.
- We use a helper script that writes OSC 52 directly to the active tmux
  client TTY.

Relevant files:

- ``_tmux.conf``
- ``bin/tmux-osc52-copy``
- ``_config/ghostty/config``

Required Ghostty settings:

::

    clipboard-read = allow
    clipboard-write = allow

tmux bindings in copy-mode-vi:

- ``v`` starts selection
- ``y`` copies selection to local clipboard
- ``Enter`` copies selection to local clipboard
- mouse drag release copies selection to local clipboard

Quick test (inside tmux on remote host):

::

    printf '\e]52;c;%s\a' "$(printf 'osc52-test' | base64 | tr -d '\n')"

If paste on macOS does not work:

1. Test OSC 52 outside tmux over mosh.
2. Confirm tmux config is reloaded: ``prefix + r``.
3. Verify helper exists and is executable: ``~/dotfiles/bin/tmux-osc52-copy``.

