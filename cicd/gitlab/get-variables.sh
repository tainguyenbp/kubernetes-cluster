
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ACCESS_TOKEN=''
PROJECT_URL=''
FILE_ENV='gitlab.env.yml'

glci getAll --token ${ACCESS_TOKEN} --url ${PROJECT_URL} --output ${FILE_ENV}
