c.auto_save.interval = 15000  # milliseconds
c.auto_save.session = True

c.content.print_element_backgrounds = False
c.content.user_stylesheets = ["user-stylesheet.css"]
c.content.cache.size = 52428800
c.content.webgl = False
c.content.geolocation = False
c.content.plugins = False
#c.content.pdfjs = True  # not available with webengine

# available qt-flags:
#   Qt: http://doc.qt.io/qt-5/qapplication.html#QApplication
#   Chromium: https://cs.chromium.org/chromium/src/content/public/common/content_switches.cc
#   --blink-settings: https://cs.chromium.org/chromium/src/third_party/WebKit/Source/core/frame/Settings.json5
c.qt.args = [
    "disable-reading-from-canvas",
    "enable-strict-mixed-content-checking",
#    "disable-remote-fonts",
]

c.downloads.location.directory = "~/stuff/"
c.downloads.location.prompt = False
c.downloads.location.remember = False
c.downloads.position = "bottom"

c.history_gap_interval = 60  # minutes

c.completion.timestamp_format = "%Y-%m-%d %H:%M:%S"

c.hints.mode = "number"
c.hints.scatter = False
c.hints.auto_follow_timeout = 500  # milliseconds

c.input.forward_unbound_keys = "none"
c.input.partial_timeout = 1000
c.input.insert_mode.plugins = True
c.input.links_included_in_focus_chain = False

c.keyhint.blacklist = ["*"]

c.new_instance_open_target = "tab-silent"
c.new_instance_open_target_window = "last-focused"

c.tabs.background = True
c.tabs.show = "multiple"
c.tabs.padding["bottom"] = 1
c.tabs.title.format = "{perc}{index}: {title}"

c.spellcheck.languages = ["en-GB", "en-US", "cs-CZ"]

c.url.start_pages = ["https://start.duckduckgo.com"]
c.url.searchengines = {
    "DEFAULT":  "https://duckduckgo.com/?q={}",
    "ddg":      "https://duckduckgo.com/?q={}",
    "wiki":     "https://wiki.archlinux.org/index.php?title=Special:Search&search={}&go=Go",
    "archpkgs": "https://archlinux.org/packages/?q={}",
    "aur":      "https://aur.archlinux.org/packages/?O=0&K={}",
    "bbs":      "https://bbs.archlinux.org/search.php?keywords={}&action=search",
    "wp":       "https://en.wikipedia.org/w/index.php?search={}",
    "wp-cs":    "https://cs.wikipedia.org/w/index.php?search={}",
    "csfd":     "http://www.csfd.cz/hledat/?q={}",
    "imdb":     "http://www.imdb.com/find?ref_=nv_sr_fn&q={}&s=all",
    "mw":       "https://www.mediawiki.org/w/index.php?title=Special:Search&search={}&go=Go",
}

c.colors.statusbar.url.success.http.fg = "lime"
c.colors.statusbar.url.success.https.fg = "lime"

c.fonts.completion.entry = "8pt monospace"
c.fonts.downloads = "8pt monospace"
c.fonts.hints = "bold 8pt monospace"
c.fonts.keyhint = "8pt monospace"
c.fonts.messages.error = "8pt monospace"
c.fonts.messages.info = "8pt monospace"
c.fonts.messages.warning = "8pt monospace"
c.fonts.statusbar = "9pt monospace"
c.fonts.tabs = "8pt monospace"
c.fonts.monospace = "monospace"
c.fonts.web.family.fixed = "monospace"



c.aliases = {
    "set": "set -t",
    # TODO: add "bind": "bind -t" after https://github.com/qutebrowser/qutebrowser/issues/2988 is implemented
}



# when the defaults were not unset yet
if c.bindings.default:

    # my bindings
    c.bindings.commands = {
        "caret": c.bindings.default["caret"],
        "command": c.bindings.default["command"],
        "hint": c.bindings.default["hint"],
        "prompt": c.bindings.default["prompt"],
        "insert": {
            "<Ctrl-I>": "open-editor",
            "<Escape>": "leave-mode",
            "<Shift-Ins>": "insert-text {primary}",
        },
        "normal": {
            "<Escape>": "clear-keychain ;; search ;; fullscreen --leave",
            "<Return>": "follow-selected",
            "<back>": "back",
            "<forward>": "forward",
            "=": "zoom",
            "+": "zoom-in",
            "-": "zoom-out",
            ".": "repeat-command",
            "/": "set-cmd-text /",
            ":": "set-cmd-text :",
            "?": "set-cmd-text ?",

            ";I": "hint images tab",
            ";O": "hint links fill :open -t -r {hint-url}",
            ";R": "hint --rapid links window",
            ";Y": "hint links yank-primary",
            ";b": "hint all tab-bg",
            ";d": "hint links download",
            ";f": "hint all tab-fg",
            ";h": "hint all hover",
            ";i": "hint images",
            ";o": "hint links fill :open {hint-url}",
            ";r": "hint --rapid links tab-bg",
            ";t": "hint inputs",
            ";y": "hint links yank",

            "b": "set-cmd-text -s :quickmark-load",
            "B": "set-cmd-text -s :quickmark-load -t",
            "f": "hint",
            "F": "hint all tab",
            "h": "scroll left",
            "j": "scroll down",
            "k": "scroll up",
            "l": "scroll right",
            "<left>": "scroll left",
            "<down>": "scroll down",
            "<up>": "scroll up",
            "<right>": "scroll right",
            "gg": "scroll-to-perc 0",
            "G": "scroll-to-perc",
            "<Ctrl-D>": "scroll-page 0 0.5",
            "<Ctrl-U>": "scroll-page 0 -0.5",
            "d": "tab-close",
            "u": "undo",
            "v": "enter-mode caret",
            "i": "enter-mode insert",
            "q": "record-macro",
            "@": "run-macro",
            "r": "reload",
            "R": "reload -f",
            "H": "back",
            "L": "forward",
            "J": "tab-prev",
            "K": "tab-next",
            "<ctrl-shift-j>": "tab-move -",
            "<ctrl-shift-k>": "tab-move +",
            "n": "search-next",
            "N": "search-prev",
            "m": "quickmark-save",
            "M": "bookmark-add",
            "o": "set-cmd-text -s :open",
            "O": "set-cmd-text :open {url}",
            "t": "set-cmd-text -s :open -t",
            "T": "set-cmd-text :open -t {url}",
            "pP": "open -- {primary}",
            "pp": "open -- {clipboard}",
            "PP": "open -t -- {primary}",
            "Pp": "open -t -- {clipboard}",
            "[[": "navigate prev",
            "]]": "navigate next",
            "{{": "navigate prev -t",
            "}}": "navigate next -t",
            "gu": "navigate up",
            "yD": "yank domain -s",
            "yP": "yank pretty-url -s",
            "yT": "yank title -s",
            "yY": "yank -s",
            "yd": "yank domain",
            "yp": "yank pretty-url",
            "yt": "yank title",
            "yy": "yank",
            "<ctrl+c>": "yank selection",
        },
        "passthrough": {
            "<Escape>": "leave-mode",
        },
        "register": {
            "<Escape>": "leave-mode",
        },
    }

    # ignore all defaults
    c.bindings.default = {}

    # key aliases
    c.bindings.key_mappings = {
        "<Ctrl-Enter>": "<Ctrl-Return>",
        "<Enter>": "<Return>",
        "<Shift-Enter>": "<Return>",
        "<Shift-Return>": "<Return>",
    }
