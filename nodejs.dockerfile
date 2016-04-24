FROM pottava/nodejs:5.8

RUN mkdir -p /var/www

WORKDIR /var/www

ADD ./nodejs/package.json package.json
ADD ./nodejs/.babelrc .babelrc
ADD ./react/src/counter.js views/counter.js
ADD ./nodejs/index.js index.js
ADD ./nodejs/server server

RUN npm i

EXPOSE 3000

CMD ["npm", "start"]
