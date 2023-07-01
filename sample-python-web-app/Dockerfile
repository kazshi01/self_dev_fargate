FROM nginx

# Install python and pip
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    && pip3 install pipenv \
    && rm -rf /var/lib/apt/lists/*

# install our code
ADD . /home/docker/code/

# Configure Nginx
RUN ln -s /home/docker/code/nginx-app.conf /etc/nginx/conf.d/ \
    && mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.ORIGINAL

# Install application requirements
WORKDIR /home/docker/code
RUN pipenv install

# Start uWSGI daemon
EXPOSE 80 
CMD ["pipenv", "run", "./start.sh"]
