service=${1-gammastep}
config=${2-~/.config/redshift.conf}

$service -c $config
