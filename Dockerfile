FROM ubuntu:18.04

# 署名
LABEL name="nfangxu"
LABEL email="nfangxu@gmail.com"

# 配置镜像源
COPY conf/sources.list /etc/apt/sources.list

# 配置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

# 安装 PHP Apache supervisor
RUN apt update && apt install -y \
    php php-bcmath php-bz2 php-curl php-gd php-mbstring php-mysql php-zip php-xml \
    apache2 \
    supervisor

# supervisor
COPY conf/supervisord.conf /etc/supervisord.conf
COPY conf/default.conf /etc/apache2/sites-available/000-default.conf
ADD src /var/www/html

# 启动
COPY init.sh /init.sh
RUN chmod 755 /init.sh

WORKDIR /var/www/html

ENTRYPOINT [ "/init.sh" ]

EXPOSE 80 443

CMD [ "/bin/bash", "-c"]