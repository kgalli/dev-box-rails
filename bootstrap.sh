# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    sudo apt-get -y install "$@" >/dev/null 2>&1
}

sudo apt-get update >/dev/null 2>&1

install 'build essentials and libraries' zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
install 'Git' git
install 'curl' curl libcurl4-openssl-dev
install 'memcached' memcached

# Install sqlite3 -- installed by rvm if autolibs enabled
install 'sqlite3' libsqlite3-dev, sqlite3

# Install MySQL set root password to 'root' and
# create super user vagrant with password 'vagrant'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install 'MySQL' mysql-server libmysqlclient-dev
mysql -uroot -proot <<SQL
CREATE USER 'vagrant'@'localhost' IDENTIFIED BY 'vagrant';
GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'localhost';
FLUSH PRIVILEGES;
SQL

# Install PostgreSQL and create vagrant user with
# super user privileges
install 'PostgreSQL' postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant

install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev

# Needed for docs generation.
sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install Ruby via ruby version manager (rvm)
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --autolibs=4
source "$HOME/.rvm/scripts/rvm"

rvm autolibs enable
rvm requirements
rvm reload

rvm install 2.1.5
rvm use --default 2.1.5

# Install ExecJS runtime  NodeJS via node version manager (nvm)
curl https://raw.githubusercontent.com/creationix/nvm/v0.22.0/install.sh | bash
source "$HOME/.nvm/nvm.sh"

nvm install stable
nvm alias default stable

