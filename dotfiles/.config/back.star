[palettes.catppuccin_mocha]
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"
text = "#cdd6f4"
subtext1 = "#bac2de"
subtext0 = "#a6adc8"
overlay2 = "#9399b2"
overlay1 = "#7f849c"
overlay0 = "#6c7086"
surface2 = "#585b70"
surface1 = "#45475a"
surface0 = "#313244"
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"

palette = "catppuccin_mocha"

# ~/.config/starship.toml

add_newline = false
command_timeout = 1000

format = """
$character\
$os$hostname\
$directory\
$git_branch\
$git_status \
$python\
$aws\
$golang\
$java\
$nodejs\
$rust\
$ruby\
$scala\
$dart\
$conda\
$pijul_channel\
$lua\
$rlang\
$package\
$buf\
$memory_usage\
$docker_context\
[](#1C3A5E)$time[ ](#1C3A5E)$cmd_duration
[└─>](bold green) """


continuation_prompt = '▶▶ '

[character]
success_symbol = "🚀 "
error_symbol = "🔥 "

[time]
disabled = false
time_format = "%r" # Hour:Minute Format
style = "bg:#1d2230"
format = '[[ 󱑍 $time ](bg:#1C3A5E fg:#8DFBD2)]($style)'

[cmd_duration]
format = 'last command: [$duration](bold yellow)'

# ---

[os]
format = '[$symbol](bold white) '   
disabled = false

[os.symbols]
Macos = '󰀵'

# Shows the hostname
[hostname]
ssh_only = false
format = 'on [$hostname](bold yellow) '
disabled = false
ssh_symbol = " "

# Shows current directory
[directory]
truncation_length = 3
fish_style_pwd_dir_length=2
home_symbol = '󰋜 ~'
read_only_style = '197'
read_only = '  '
format = 'at [$path]($style)[$read_only]($read_only_style) '

# Shows current git branch
[git_branch]
symbol = " "
format = 'via [$symbol$branch]($style)'
# truncation_length = 4
truncation_symbol = '…/'
style = 'bold green'

# Shows current git status
[git_status]
format = '[$all_status$ahead_behind]($style) '
style = 'bold green'
conflicted = '🏳'
up_to_date = ''
untracked = ' '
ahead = '⇡${count}'
diverged = '⇕⇡${ahead_count}⇣${behind_count}'
behind = '⇣${count}'
stashed = ' '
modified = ' '
staged = '[++\($count\)](green)'
renamed = '襁 '
deleted = ' '


# ---

[aws]
symbol = "  "

[buf]
symbol = " "

[c]
symbol = " "

[conda]
symbol = " "

[dart]
symbol = " "

[docker_context]
symbol = " "

[golang]
symbol = " "

[java]
symbol = " "

[lua]
symbol = " "

[memory_usage]
symbol = "󰍛 "
disabled = true
style='bold dimmed white'
threshold = 1
format = "$symbol [${ram}(|${swap})]($style) "

[nodejs]
symbol = " "

[package]
symbol = "󰏗 "

[pijul_channel]
symbol = " "

[python]
symbol = " "
pyenv_version_name = true

[ruby]
symbol = " "

[rlang]
symbol = "󰟔 "

[rust]
symbol = " "

[scala]
symbol = " "
