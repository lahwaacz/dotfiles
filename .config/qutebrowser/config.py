config.load_autoconfig(False)

c.editor.command = ["alacritty", "--command", "bash", "-c", "vim -f \"{file}\" -c \"normal {line}G{column0}l\""]

c.auto_save.interval = 15000  # milliseconds
c.auto_save.session = True
c.session.lazy_restore = True

c.content.print_element_backgrounds = False
c.content.user_stylesheets = ["user-stylesheet.css"]
c.content.cache.size = 52428800
c.content.webgl = False
c.content.geolocation = False
c.content.plugins = False
#c.content.pdfjs = True  # not available with webengine
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    # uBlock - built-in filters - https://github.com/uBlockOrigin/uAssets/tree/master/filters
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt",
    # uBlock - CZE, SVK: EasyList Czech and Slovak
    "https://raw.githubusercontent.com/tomasko126/easylistczechandslovak/master/filters.txt",
]

# disable 3rdparty cookies
c.content.cookies.accept = "no-3rdparty"

# available qt-flags:
#   Qt: http://doc.qt.io/qt-5/qapplication.html#QApplication
#   Chromium: https://cs.chromium.org/chromium/src/content/public/common/content_switches.cc
#   --blink-settings: https://cs.chromium.org/chromium/src/third_party/WebKit/Source/core/frame/Settings.json5
c.qt.args = [
    # NOTE: login to gitlab.com requires reading from canvas
#    "disable-reading-from-canvas",
    "enable-strict-mixed-content-checking",
#    "disable-remote-fonts",
]

# workaround for high-memory usage
# https://github.com/qutebrowser/qutebrowser/issues/1476#issuecomment-889859126
#c.qt.force_software_rendering = "qt-quick"

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
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = True
c.input.insert_mode.leave_on_load = True
c.input.insert_mode.plugins = True
c.input.links_included_in_focus_chain = False

c.keyhint.blacklist = ["*"]

c.new_instance_open_target = "tab-silent"
c.new_instance_open_target_window = "last-focused"

c.tabs.background = True
c.tabs.show = "multiple"
c.tabs.padding["bottom"] = 1
c.tabs.title.format = "{perc}{index}: {current_title}"

c.spellcheck.languages = ["en-GB", "en-US", "cs-CZ"]

c.url.start_pages = ["https://start.duckduckgo.com"]
c.url.searchengines = {
    "DEFAULT":  "https://duckduckgo.com/?q={}",
    "ddg":      "https://duckduckgo.com/?q={}",
    "wiki":     "https://wiki.archlinux.org/index.php?title=Special:Search&search={}&go=Go",
    "man":      "https://man.archlinux.org/search?q={}&go=Go",
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
c.fonts.hints = "bold monospace"
c.fonts.keyhint = "9pt monospace"
c.fonts.messages.error = "9pt monospace"
c.fonts.messages.info = "9pt monospace"
c.fonts.messages.warning = "9pt monospace"
c.fonts.statusbar = "9pt monospace"
c.fonts.tabs.selected = "8pt monospace"
c.fonts.tabs.unselected = "8pt monospace"
c.fonts.web.family.fixed = "monospace"

# per-site whitelist for javascript
c.content.javascript.enabled = False
import os.path
jswhitelist_path = os.path.join(os.path.dirname(__file__), "javascript_whitelist.txt")
if os.path.isfile(jswhitelist_path):
    with open(jswhitelist_path, "r") as f:
        for line in f.readlines():
            pattern = line.split("#", maxsplit=1)[0]
            pattern = pattern.strip()
            if pattern:
                with config.pattern(pattern) as p:
                    p.content.javascript.enabled = True

# skip certain URLs in the history completion
# documentation for URL match patterns: https://developer.chrome.com/apps/match_patterns
c.completion.web_history.exclude = [
    "https://wiki.archlinux.org/index.php?*",
]



c.aliases = {
    "set": "set -t",
    # TODO: add "bind": "bind -t" after https://github.com/qutebrowser/qutebrowser/issues/2988 is implemented
}



# when the defaults were not unset yet
if c.bindings.default:

    # copy defaults
    c.bindings.commands = c.bindings.default

    # overwrite with my bindings for some modes
    c.bindings.commands["insert"] = {
            "<Ctrl-I>": "edit-text",
            "<Escape>": "mode-leave",
            "<Shift-Ins>": "insert-text {primary}",
        }
    c.bindings.commands["normal"] = {
            "<Escape>": "clear-keychain ;; search ;; fullscreen --leave",
            "<Return>": "selection-follow",
            "<back>": "back",
            "<forward>": "forward",
            "=": "zoom",
            "+": "zoom-in",
            "-": "zoom-out",
            ".": "cmd-repeat-last",
            "/": "cmd-set-text /",
            ":": "cmd-set-text :",
            "?": "cmd-set-text ?",

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

            "b": "cmd-set-text -s :quickmark-load",
            "B": "cmd-set-text -s :quickmark-load -t",
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
            "v": "mode-enter caret",
            "i": "mode-enter insert",
            "q": "macro-record",
            "@": "macro-run",
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
            "o": "cmd-set-text -s :open",
            "O": "cmd-set-text :open {url}",
            "t": "cmd-set-text -s :open -t",
            "T": "cmd-set-text :open -t {url}",
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
        }
    c.bindings.commands["passthrough"] = {
            "<Escape>": "mode-leave",
        }
    c.bindings.commands["register"] = {
            "<Escape>": "mode-leave",
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
