FROM java:8-jre
MAINTAINER cdyue <acrhwfy@gmail.com>

ENV ES_VERSION="2.2.1"

# es needs non-root user to start

RUN cd /tmp && curl -OL https://github.com/medcl/elasticsearch-rtf/archive/${ES_VERSION}.zip && \
  unzip ${ES_VERSION}.zip -d /usr/share && rm /tmp/${ES_VERSION}.zip && \
  mv /usr/share/elasticsearch-rtf-${ES_VERSION} /usr/share/elasticsearch && \
  groupadd es && useradd -g es es && \
  for path in data config logs config/scripts; do mkdir -p "/usr/share/elasticsearch/$path"; done && \
  chown -R es:es /usr/share/elasticsearch && \
  sed -ri 's/^index.analysis.analyzer.default.type: keyword/#index.analysis.analyzer.default.type: keyword/;s/^#index.analysis.analyzer.default.type: mmseg/index.analysis.analyzer.default.type: mmseg/' /usr/share/elasticsearch/config/elasticsearch.yml


ENV PATH /usr/share/elasticsearch/bin:$PATH

VOLUME /usr/share/elasticsearch/config

VOLUME /usr/share/elasticsearch/data

VOLUME /usr/share/elasticsearch/logs

USER es

EXPOSE 9200 9300

CMD ["elasticsearch", "--network.host", "_non_loopback_"]
