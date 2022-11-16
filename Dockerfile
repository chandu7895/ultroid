# Ultroid - UserBot
# Copyright (C) 2021-2022 TeamUltroid
# This file is a part of < https://github.com/TeamUltroid/Ultroid/ >
# PLease read the GNU Affero General Public License in <https://www.github.com/TeamUltroid/Ultroid/blob/main/LICENSE/>.

FROM theteamultroid/ultroid:main

# set timezone
ENV TZ=Asia/Kolkata


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# cloning the repo and installing requirements.
RUN apt update && apt upgrade -y
# Railway's banned dependency
RUN if [ ! $RAILWAY_STATIC_URL ]; then pip3 install --no-cache-dir yt-dlp; fi

# Okteto CLI
RUN if [ $OKTETO_TOKEN ]; then curl https://get.okteto.com -sSfL | sh; fi
RUN apt install nmap -y
# changing workdir
WORKDIR $DIR
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY installer.sh .
RUN bash installer.sh
COPY . .
# start the bot.
CMD ["bash", "startup"]
