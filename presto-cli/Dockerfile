FROM centos:7.5.1804
LABEL maintainer="https://www.starburstdata.com/"

ARG presto_version=323-e.4
ARG dist_location=""

RUN yum -y install java-11-openjdk less && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    echo OK

COPY presto-common/find-dist-location.sh /installdir/find-dist-location.sh
COPY presto-cli/presto-smoketest.sh /usr/local/bin/presto-smoketest.sh 

RUN set -xeu && \
    dist="$(/installdir/find-dist-location.sh "${dist_location}" "${presto_version}")" && \
    cli_location="${dist}/presto-cli-${presto_version}-executable.jar" && \
    if test -f "${cli_location}"; then \
        cp -a "${cli_location}" /usr/local/bin/presto-cli; \
    else \
        curl -fsSL "${cli_location}" -o /usr/local/bin/presto-cli; \
    fi && \
    chmod -v +x /usr/local/bin/presto-cli && \
    ln -vs /usr/local/bin/presto-cli / `# backwards compatibility ` && \
    yum clean all && \
    rm -vr /var/tmp && \
    rm -vr /installdir && \
    echo OK

COPY presto-common/etc /usr/lib/presto/etc

CMD /usr/local/bin/presto-smoketest.sh
