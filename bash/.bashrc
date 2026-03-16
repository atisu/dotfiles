if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

. ~/.bashrc-atisu

PATH=/usr/local/bin:$PATH
export PATH

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/atisu/.lmstudio/bin"
# End of LM Studio CLI section

