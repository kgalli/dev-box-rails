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
install 'ack-grep (ack)' ack-grep
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

# Install sqlite3 -- installed by rvm if autolibs enabled
install 'sqlite3' libsqlite3-dev sqlite3

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
# super user privileges and set vagrant as password
install 'PostgreSQL' postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant
psql -d template1 --command "ALTER USER vagrant WITH ENCRYPTED PASSWORD 'vagrant';"
PG_HOME=$(psql --version 2>&1 | tail -1 | awk '{print $3}' | sed 's/\./ /g' | awk '{print $1 "." $2}')
echo "host all vagrant localhost md5" | sudo tee -a /etc/postgresql/$PG_HOME/main/pg_hba.conf
sudo service postgresql restart

# Install Nokogiri dependencies to be able to gem install nokogiri
install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev

# Install PhantomJS to /usr/local/share and set links
echo intalling PhantomJS
sudo apt-get install libfontconfig1 libfreetype6 libstdc++6 >/dev/null 2>&1
export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
curl -LO https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 >/dev/null 2>&1
sudo mv $PHANTOM_JS.tar.bz2 /usr/local/share/
cd /usr/local/share/
sudo tar xvjf $PHANTOM_JS.tar.bz2 >/dev/null 2>&1
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/share/phantomjs
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin/phantomjs
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/bin/phantomjs

# Needed for docs generation.
sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Install Ruby version manager (rbenv)
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
# Install ruby-build to enhance rbenv to install Ruby versions easily
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

rbenv install 2.1.5
rbenv rehash
rbenv global 2.1.5

# Install ExecJS runtime  NodeJS via node version manager (nvm)
git clone https://github.com/OiNutter/nodenv.git ~/.nodenv
echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(nodenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
git clone git://github.com/OiNutter/node-build.git ~/.nodenv/plugins/node-build

nodenv install 0.10.33
nodenv rehash
nodenv global 0.10.33

