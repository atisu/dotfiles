if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

. ~/.bashrc-atisu

PATH=/usr/local/bin:$PATH
export PATH
