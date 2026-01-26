#==========================================#
#        Qtile Configuation
#==========================================#

#--------------------------
#  Python imports
#--------------------------
import os
import subprocess
import sys
import colors
from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, ScratchPad, DropDown, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook

#--------------------------
#  Start Up Applications
#--------------------------
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call(home)

#--------------------------
#  Software Variables
#--------------------------
mod = "mod4"           # Super/Windows Key
myTerm = "alacritty"    # My terminal of choice
myBrowser = "firefox"  # My browser of choice
myFileManager = "dolphin" # Dolphin File Manager"
myEmail = "thunderbird" # Email Client
myMusic = "spotify" # Music
myAppLauncher = "rofi -show drun -show-icons" # App Launcher

#--------------------------
#  Keys
#--------------------------
keys = [
    # Essentials
    Key([mod], "return", lazy.spawn(myTerm), desc="Terminal"),
    Key([mod], "w", lazy.spawn(myBrowser), desc='Web browser'),
    Key([mod], "m", lazy.spawn(myFileManager), desc='File Manager'),
    Key([mod], "b", lazy.hide_show_bar(position='all'), desc="Toggles the bar to show/hide"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    #Key([mod, "shift"], "q", lazy.spawn("dm-logout -r"), desc="Logout menu"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "print", lazy.spawn("flameshot gui"), desc="Screenshot tool"),

    # Volume Controls using pactl (PulseAudio)
    Key([mod], "F10", lazy.spawn("pamixer -d 5")), # Decrease %5
    Key([mod], "F11", lazy.spawn("pamixer -i 5")), # Increase %5
    Key([mod], "F12", lazy.spawn("pamixer -t")), # Mute

    # Add Rofi
    Key([mod], "space", lazy.spawn(myAppLauncher), desc='Run Launcher'),

    # Switch between windows
    Key([mod], "left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "up", lazy.layout.up(), desc="Move focus up"),
    Key([mod, "shift"],"space", lazy.layout.next(), desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    Key([mod, "shift"], "left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "up", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    Key([mod, "control"], "left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # multiple stack panes
    # Key(
    #     [mod, "shift"],
    #     "Return",
    #     lazy.layout.toggle_split(),
    #     desc="Toggle between split and unsplit sides of stack",
    # ),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window",),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

#--------------------------
#  Group Settings
#--------------------------
groups = []

group_names = ["1", "2", "3", "4"]
group_labels = ["", # Internet
               "", # Folder
               "", # Gamepad
               ""] # Social

# The default layout for each of the 5 workspacesm
group_layouts = ["columns", "columns", "columns", "columns"]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )

#--------------------------
#  Scratchpad Settings
#--------------------------
groups.append(
     ScratchPad("scratchpad", [
         DropDown("term", myTerm, width=0.8, height=0.6, x=0.1, y=0.1, opacity=1),
         DropDown("files", myFileManager, width=0.8, height=0.6, x=0.1, y=0.1, opacity=1),
         DropDown("music", myMusic, width=0.8, height=0.6, x=0.1, y=0.1, opacity=1),
     ])
 )

keys.extend([
    Key([mod], "f1", lazy.group["scratchpad"].dropdown_toggle("term"), desc="Toggle terminal scratchpad"),
    Key([mod], "f2", lazy.group["scratchpad"].dropdown_toggle("files"), desc="Toggle file manager scratchpad"),
    Key([mod], "f3", lazy.group["scratchpad"].dropdown_toggle("music"), desc="Toggle music scratchpad"),
])

#--------------------------
#  Colour & Themeing
#--------------------------
colors = colors.Luna

layout_theme = {"border_width": 4,
                "margin": 5,
                "border_focus": colors[7],
                "border_normal": colors[0]
                }

#--------------------------
#  Layouts
#--------------------------
layouts = [
    layout.Columns(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Tile(**layout_theme),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]


#==========================================#
#             Qtile Bar & Widgets          #
#==========================================#
widget_defaults = dict(
    font="Ubuntu Bold",
    fontsize=12,
    padding=0,
    background=colors[0]
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper = '/etc/nixos/assets/wallpapers/luna-os-abstract.png',
        wallpaper_mode = 'fill',

        top=bar.Bar(
            [
                widget.Prompt(
                        font = "Ubuntu Mono",
                        fontsize=14,
                        foreground = colors[1]
                ),
                # widget.TextBox(
                #         text="",
                #         mouse_callbacks={"Button1": lazy.spawn(myAppLauncher)},
                #         fontsize = 12,
                #         padding = 8,
                #         ),
                # widget.TextBox(
                #         text = '|',
                #         font = "Ubuntu Mono",
                #         foreground = colors[9],
                #         padding = 2,
                #         fontsize = 14
                #         ),
                widget.GroupBox(
                        fontsize = 11,
                        margin_y = 5,
                        margin_x = 14,
                        padding_y = 0,
                        padding_x = 2,
                        borderwidth = 3,
                        active = colors[8],
                        inactive = colors[9],
                        rounded = False,
                        highlight_color = colors[0],
                        highlight_method = "line",
                        this_current_screen_border = colors[7],
                        this_screen_border = colors [4],
                        other_current_screen_border = colors[7],
                        other_screen_border = colors[4],
                        ),
                # widget.TextBox(
                #         text = '|',
                #         font = "Ubuntu Mono",
                #         foreground = colors[9],
                #         padding = 2,
                #         fontsize = 14
                #         ),
                # widget.TextBox(
                #         text="🦊",
                #         mouse_callbacks={"Button1": lazy.spawn(myBrowser)},
                #         fontsize = 12,
                #         padding = 8,
                #         foreground = colors[3],
                #         ),
                # widget.TextBox(
                #         text="✉️",
                #         mouse_callbacks={"Button1": lazy.spawn(myEmail)},
                #         fontsize = 12,
                #         padding = 8,
                #         foreground = colors[3],
                #         ),
                # widget.TextBox(
                #         text="📁",
                #         mouse_callbacks={"Button1": lazy.spawn(myFileManager)},
                #         fontsize = 12,
                #         padding = 8,
                #         foreground = colors[3],
                #         ),
                # widget.TextBox(
                #         text="🎧",
                #         mouse_callbacks={"Button1": lazy.spawn(myMusic)},
                #         padding=5
                #         ),
                widget.TextBox(
                        text = '|',
                        font = "Ubuntu Mono",
                        foreground = colors[9],
                        padding = 2,
                        fontsize = 14
                        ),
                widget.CurrentLayout(
                        padding = 5,
                        scale=0.7,
                        foreground = colors[1],
                            ),
                # widget.CurrentLayoutIcon(
                #         foreground = colors[1],
                #         padding = 5,
                #         ),
                widget.TextBox(
                        text = '|',
                        font = "Ubuntu Mono",
                        foreground = colors[9],
                        padding = 2,
                        fontsize = 14
                        ),
                widget.WindowName(
                        foreground = colors[6],
                        padding = 8,
                        max_chars = 40
                        ),
                #widget.CheckUpdates(
                            #distro='Arch_checkupdates',
                            #update_interval=1800,  # check every 30 minutes
                            #display_format=' {updates}',  # Nerd Font icon, optional
                            #no_update_string=' 0',
                            #colour_have_updates=colors[7][0],
                            #colour_no_updates= colors[4],
                            #padding = 8,
                            #mouse_callbacks={
                            #    'Button1': lambda: qtile.cmd_spawn('alacritty -e sudo pacman -Syu')
                                            #},
                            #),
                widget.Bluetooth(
                    foreground = colors[3],
                    padding = 8,
                    default_text=' {connected_devices}',
                    default_show_battery='True',
                    mouse_callbacks={
                    'Button1': lambda: qtile.cmd_spawn('blueman-manager')},
                    ),
                # widget.GenPollText(
                #         update_interval = 300,
                #         func = lambda: subprocess.check_output("printf $(uname -r)", shell=True, text=True),
                #         foreground = colors[3],
                #         padding = 8,
                #         fmt = '❤  {}',
                #         ),
                widget.CPU(
                        foreground = colors[4],
                        padding = 8,
                        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
                        format = '  Cpu: {load_percent}%',
                        ),
                widget.Memory(
                        foreground = colors[8],
                        padding = 8,
                        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
                        format = '{MemUsed: .0f}{mm}',
                        fmt = '🖥  Mem: {}',
                        ),
                widget.DF(
                        update_interval = 60,
                        foreground = colors[5],
                        padding = 8,
                        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-disk')},
                        partition = '/',
                        format = '{uf}{m} free',
                        fmt = '🖴  Disk: {}',
                        visible_on_warn = False,
                        ),
                widget.Volume(
                        foreground = colors[7],
                        padding = 8,
                        fmt = '🕫  Vol: {}',
                        mouse_callbacks={"Button1": lazy.spawn("pavucontrol")},
                        ),
                widget.Clock(
                        foreground = colors[8],
                        padding = 8,
                        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('notify-date')},
                        ## Uncomment for date and time
                        format = "⧗  %a, %b %d - %H:%M",
                        ## Uncomment for time only
                        #format = "⧗  %I:%M %p",
                        ),
                widget.TextBox(
                        text = '|',
                        font = "Ubuntu Mono",
                        foreground = colors[9],
                        padding = 2,
                        fontsize = 14
                        ),
                # widget.StatusNotifier(
                #     padding = 6
                #     ),
                widget.Systray(
                   padding = 6
                   ),
                widget.TextBox(
                        text = '|',
                        font = "Ubuntu Mono",
                        foreground = colors[9],
                        padding = 2,
                        fontsize = 14
                        ),

                widget.QuickExit(
                    default_text='  ',
                    countdown_format ='[{}]',
                    countdown_start = 5,
                    padding = 2,
                    ),
                widget.Spacer(length = 4),
            ],
            22,
        ),
    ),
]

#==========================================#
#           Drag Floating Layouts          #
#==========================================#
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

wmname = "LG3D"

#--------------------------
#  Required Software
#--------------------------
# ttf-font-awesome
# rofi
# pavucontrol
# alsa-utils
# picom
# blueman (Bluetooth)
# flameshot #Screenshot
# copyq #Clipboard
# pamixer
