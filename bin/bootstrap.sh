#!/bin/bash
wget https://github.com/BashGui/easybashgui/archive/refs/tags/12.0.5.tar.gz
mkdir -p ~/Devel/newprj && tar -zxvf 12.0.5.tar.gz -C ~/Devel/newprj
cd ~/Devel/newprj && ln -s lib/easybashlib easybashlib && ln -s lib/easybashgui.lib easybashgui.lib
echo -e "source src/easybashgui\nmessage hola" > ~/Devel/newprj/newprogram
bash ~/Devel/newprj/newprogram
