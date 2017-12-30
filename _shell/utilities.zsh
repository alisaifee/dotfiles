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
