function set-aws-credentials
{
    if [ -e ~/.aws-credentials/$1 ];
        then
            credentials=($(cat ~/.aws-credentials/$1 | tail -n 1 | awk -F "," '{print $2" "$3}'));
            export AWS_ACCESS_KEY_ID=$credentials[1];
            export AWS_SECRET_ACCESS_KEY=$credentials[2];
    else
        echo "Unable to located $1 credentials";
    fi;
}


export PATH="$HOME/.antigen/bundles/bigH/git-fuzzy/bin:$PATH"
export GF_PREFERRED_PAGER="delta --theme=gruvbox --highlight-removed -w __WIDTH__"
export GF_BAT_THEME=gruvbox

