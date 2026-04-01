# vim: filetype=gitconfig

[credential "https://gitlab.com"]
    username = lahwaacz

[credential]
    helper = cache --timeout 43200  # 12 hours
    helper = oauth -device
