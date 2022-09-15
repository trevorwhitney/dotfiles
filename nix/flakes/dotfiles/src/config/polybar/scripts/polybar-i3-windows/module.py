#! /usr/bin/python3

import os
import asyncio
import getpass
import i3ipc
import platform

from icon_resolver import IconResolver

#: Max length of single window title
MAX_LENGTH = 24
#: Max # of window titles to display
MAX_WINDOWS = 9
#: Base 1 index of the font that should be used for icons
ICON_FONT = 3

HOSTNAME = platform.node()
USER = getpass.getuser()

# use xprop to get class names
ICONS = [
    ('name=vim;class=kitty', ' '),
    ('name=nvim;class=kitty', ' '),
    ('name=vim;class=Alacritty', ' '),
    ('name=nvim;class=Alacritty', ' '),
    ('class=Gvim', ' '),
    ('class=Slack', ' '),
    ('class=Spotify', ' '),
    ('class=chromium-browser', ' '),
    ('class=firefox', ' '),
    ('class=kitty', ' '),
    ('class=Alacritty', ' '),
    ('class=zoom', ' '),
    ('class=Insomnia', ' '),
    ('class=1Password', ' '),
    ('class=Org.gnome.Nautilus', ' '),
    ('class=File-roller', ' '),
    ('class=Com.github.donadigo.eddy', ' '),
    ('*', ' '),
]

FORMATERS = {
    'chromium-browser': lambda title: title.replace(' - Chromium', ''),
    'firefox': lambda title: title.replace(' - Mozilla Firefox', ''),
}

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
COMMAND_PATH = os.path.join(SCRIPT_DIR, 'command.py')

icon_resolver = IconResolver(ICONS)

def main():
    i3 = i3ipc.Connection()

    i3.on('workspace::focus', on_change)
    i3.on('window::focus', on_change)
    i3.on('window', on_change)

    loop = asyncio.get_event_loop()

    loop.run_in_executor(None, i3.main)

    render_apps(i3)

    loop.run_forever()


def on_change(i3: i3ipc.Connection , e):
    render_apps(i3)


def render_apps(i3: i3ipc.Connection):
    focused_workspace = []
    workspaces = i3.get_workspaces()
    for workspace in workspaces:
        if workspace.focused:
            focused_workspace.append(workspace.num)

    tree = i3.get_tree()
    apps = tree.leaves()
    apps.sort(key=lambda app: app.workspace().name)

    current_workspace_apps = []
    focused_app = None
    if len(apps) > 0:
        focused_app = apps[0]
    for app in apps:
        if app.workspace().num in focused_workspace:
            if app.focused:
                focused_app = app
            else:
                current_workspace_apps.append(app)

    current_workspace_apps.sort(key=lambda app: app.name)
    if focused_app != None:
        current_workspace_apps.insert(0, focused_app)

    out = ' %{F#93a1a1}|%{F-} '.join(format_entry(app) for app in current_workspace_apps[0:MAX_WINDOWS])

    print(out, flush=True)


def format_entry(app: i3ipc.Con):
    title = make_title(app)
    u_color = '#b4619a' if app.focused else\
        '#e84f4f' if app.urgent else\
        '#404040'

    return '%%{u%s} %s %%{u-}' % (u_color, title)


def make_title(app: i3ipc.Con):
    out = get_prefix(app) + ' ' + format_title(app)

    if app.focused:
        out = '%{F#268bd2}' + out + '%{F-}'

    return '%%{A1:%s %s:}%s%%{A}' % (COMMAND_PATH, app.id, out)


def get_prefix(app: i3ipc.Con):
    icon = icon_resolver.resolve({
        'class': app.window_class,
        'name': app.name,
    })

    return ('%%{T%s}%s%%{T-}' % (ICON_FONT, icon))


def format_title(app: i3ipc.Con):
    klass = app.window_class
    name = app.name

    title = FORMATERS[klass](name) if klass in FORMATERS else name

    if len(title) > MAX_LENGTH:
        title = title[:MAX_LENGTH]

    return title

main()
