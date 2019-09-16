#!/bin/bash
RED="\033[0;31m"
GREEN="\033[0;32m"
ORANGE="\033[0;33m"
NC="\033[0m"

source .env

echo PROJECT_NAME 2>&1 >/dev/null
echo SHOPWARE_ENV 2>&1 >/dev/null

echo DB_HOST 2>&1 >/dev/null
echo DB_DATABASE 2>&1 >/dev/null
echo DB_USERNAME 2>&1 >/dev/null
echo DB_PASSWORD 2>&1 >/dev/null
echo DB_PORT 2>&1 >/dev/null

echo -e "${RED}===== ENVOIREMENT is: ${GREEN}$SHOPWARE_ENV${NC}${NC}"

HT_USER="webstobe"  # user for protected subdir (htaccess)
HT_PW="9050"  # password for protected subdir (htaccess)
COMPOSER=~/bin # Check for Composer Directory
CWD="$(pwd)" #Project Path

#change directory

if [ "$SHOPWARE_ENV" = "local" ]; then

    cd /var/www

    # make sure mySQL-DB is ready:
    while [[ -z $(mysql -h"$DB_HOST" -u"$DB_USERNAME" -p"$DB_PASSWORD"  <<< status)  ]]; do
        echo -e "${RED}===== Waiting for MYSQL Server ${NC}"

        sleep 2
    done
    echo -e "${GREEN}===== MYSQL Server is Good ${NC}"

    if  [ ! -f "./app/Application.php" ];
            then
                echo -e "${ORANGE}===== PREPARING INITIAL SHOPWARE-SETUP ${NC}"
                echo -e "${RED}===== existing database will be dropped ! ! ${NC}"

                rm -f composer.lock
                # first install shopware distribution via composer create-project:
                composer create-project shopware/composer-project tmp --no-interaction --stability=dev
                # move all shopware installed files
                rsync -av --no-owner --no-group --no-perms --exclude=".gitkeep" --exclude="composer.lock" --exclude="README.md" --exclude="CHANGELOG.md" --exclude="composer.json" tmp/* .
                # clean up shopware tmp folder
                rm -rf tmp
                # install shopware!
                ./app/bin/install.sh

                cp -rf $CWD/.htaccess.local $CWD/.htaccess

                echo -e "${GREEN}===== SHOPWARE-SETUP is done! ${NC}"

            else

            echo -e "${GREEN}===== SHOPWARE is already installed ${NC}"
            composer update

     fi

    echo -e "${ORANGE}${NC}"
fi


# Dev Settings
if [ "$SHOPWARE_ENV" = "dev" ];

    then

        #check if composer is installed
        if  [ -p "$COMPOSER" ];
             then
                echo -e "${GREEN}===== COMPOSER is already installed ${NC}"
             else
                echo -e "${ORANGE}===== PREPARING COMPOSER INSTALL ${NC}"
                    # Install Composer
                    mkdir -p bin
                    cd bin
                    curl -sS https://getcomposer.org/installer | php
                    mv composer.phar composer
                    echo "export PATH=\$PATH:~/bin" > .bash_profile
                    echo "alias composer="php -d allow_url_fopen=On ~/bin/composer"" > .bash_profile
                    source ~/.bashrc

                echo -e "${GREEN}===== COMPOSER INSTALL is done!${NC}"
        fi

        cd $CWD
        # only if /Application.php is not already present:
        if  [ ! -f "./app/Application.php" ];
            then
                echo -e "${ORANGE}===== PREPARING INITIAL SHOPWARE-SETUP ${NC}"
                echo -e "${RED}===== existing database will be dropped ! ! ${NC}"

                rm -f composer.lock
                # first install shopware distribution via composer create-project:
                ~/bin/composer create-project shopware/composer-project tmp --no-interaction --stability=dev
                # move all shopware installed files
                rsync -av --no-owner --no-group --no-perms --exclude=".gitkeep" --exclude="composer.lock" --exclude="README.md" --exclude="CHANGELOG.md" --exclude="composer.json" tmp/* .
                # clean up shopware tmp folder
                rm -rf tmp
                # install shopware!
                ./app/bin/install.sh

                echo -e "${GREEN}===== SHOPWARE-SETUP is done! ${NC}"

                CWDEV="$(pwd)" #DEV Path for Symlink

            else
                echo -e "${GREEN}===== SHOPWARE is already installed ${NC}"
                ~/bin/composer update
        fi

        #Dev Settings
        echo -e "${ORANGE}===== Create Development Envoirement Settings... ${NC}"

        $(mysql -h$DB_HOST -u$DB_USERNAME -p$DB_PASSWORD -e "UPDATE $DB_DATABASE.s_core_shops SET base_path='/dev'")


        if [ ! -f "./.htaccess" ]; then

            cp -rf $CWD/.htaccess.dev $CWD/.htaccess

            htpasswd -nb $HT_USER $HT_PW > $CWD/.htpasswd

            echo "
            AuthType Basic
            AuthName \"Restricted Content\"
            AuthUserFile $CWD/.htpasswd
            Require valid-user
            satisfy any
            satisfy any
            deny from all
            allow from 192.168.1.1
            allow from 46.127.225.11
            " >> $CWD/.htaccess

            # adjust path in .htaccess

        else

        echo -e "${GREEN}===== Development Envoirement done! ${NC}"

        fi

fi

    if [ "$SHOPWARE_ENV" = "local" ]; then

        echo -e "${ORANGE}===== Create Local Envoirement Settings...${NC}"

        cp -rf $CWD/.htaccess.local $CWD/.htaccess

        echo -e "${GREEN}===== Local Envoirement done! ${NC}"
        else

        echo -e "${ORANGE}${NC}"


    fi


    if [ "$SHOPWARE_ENV" = "stable" ]; then

    cd $CWD
        # only if /Application.php is not already present:
        if  [ ! -f "./app/Application.php" ];
            then
                echo -e "${ORANGE}===== PREPARING INITIAL SHOPWARE-SETUP ${NC}"
                echo -e "${RED}===== existing database will be dropped ! ! ${NC}"

                rm -f composer.lock
                # first install shopware distribution via composer create-project:
                ~/bin/composer create-project shopware/composer-project tmp --no-interaction --stability=dev
                # move all shopware installed files
                rsync -av --no-owner --no-group --no-perms --exclude=".gitkeep" --exclude="composer.lock" --exclude="README.md" --exclude="CHANGELOG.md" --exclude="composer.json" tmp/* .
                # clean up shopware tmp folder
                rm -rf tmp
                # install shopware!
                ./app/bin/install.sh

                echo -e "${GREEN}===== SHOPWARE-SETUP is done! ${NC}"

                CWDEV="$(pwd)" #DEV Path for Symlink

            else
                echo -e "${GREEN}== SHOPWARE is already installed ==${NC}"
                ~/bin/composer update
        fi

        echo -e "${GREEN}===== Create Stable Envoirement Settings...${NC}"

        if [ ! -f "./.htaccess" ]; then

            cp -rf $CWD/.htaccess.stable $CWD/.htaccess


        elif [ ! -d "$CWD/dev" ]; then

        # Create Symlink for Dev/Media Folder
        find ../ -type d -name "*.dev" -exec ln -s {} dev ';'
        find ../ -type d -name "*.dev/media" -exec mv {} media_dev ';'
        find ../ -type d -name "*.dev/media" -exec ln -s $CWD/media {} ';'


        fi

        else

        echo -e "${GREEN}===== Stable Envoirements Settings done! ${NC}"
   fi


echo -e "${GREEN}====== Shopware Envoirement Setup is done!${NC}"

exec "$@"
#/bin/bash
