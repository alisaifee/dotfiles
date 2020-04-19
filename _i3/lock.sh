set -x
#!/bin/bash
red=cc241dff
green=98971aff
blue=458588ff
yellow=d79921ff
fg=ebdbb2ff
bg=28282800
font="FiraGO Nerd Font"
size=60
iconsize=120
/usr/local/bin/i3lock \
    -k \
    -t -i ~/_dev/_git/dotfiles/wallpapers/texture.png \
    --greeter-font="$font"\
    --layout-font="$font"\
    --greetersize=$iconsize\
    --modsize=30\
    --modifpos="x+(w/2):y+(5*h/6)"\
    --greetercolor=$fg\
    --greetertext=" "\
    --ringcolor=$bg\
    --linecolor=$bg \
    --insidecolor=$bg\
    --keyhlcolor=$green\
    --bshlcolor=$red\
    --ring-width=10\
    --radius=140\
    --indpos="x+(w/2):y+(3*h/4)"\
    --greeterpos="x+120:y+120"\
    --noinputtext="﯊"\
    \
    --datecolor=$fg\
    --datestr="%A %d %B"\
    --datesize=$size\
    --date-font="$font"\
    --datepos="x+(w/2):ty+60"\
    --timecolor=$fg\
    --timestr="%I:%M %p"\
    --timesize=$size\
    --time-font="$font"\
    --timepos="x+(w/2):y+(h/2)"\
    \
    --insidewrongcolor=$bg\
    --ringwrongcolor=$bg\
    --wrong-font="$font"\
    --wrongsize=$iconsize\
    --wrongtext=""\
    --wrongcolor=$red\
    \
    --insidevercolor=$bg\
    --ringvercolor=$bg\
    --verifcolor=$yellow\
    --verif-font="$font"\
    --separatorcolor=$bg\
    --verifsize=$iconsize\
    --veriftext="羽"\


