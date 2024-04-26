# 🕵️‍♀️ ProxyCrypt
# =============
#
# Simple image based on Nginx and Alpine: ProxyCrypt adds OpenSSL and some custom configuration.
#
# Copyright © 2023–2024, California Institute of Technology ("Caltech").
# U.S. Government sponsorship acknowledged.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# • Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# • Redistributions must reproduce the above copyright notice, this list of
#   conditions and the following disclaimer in the documentation and/or other
#   materials provided with the distribution.
# • Neither the name of Caltech nor its operating division, the Jet Propulsion
#   Laboratory, nor the names of its contributors may be used to endorse or
#   promote products derived from this software without specific prior written
#   permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

FROM nginx:1.23.3-alpine


# Default env vars
# ----------------
#
# - CERT_CN: "common name" to use in the random certificate's subject
# - PROXY_REDIRECT: How Nginx should rewrite "Location" and "Refresh" headers
#
# Other variables used but not listed here:
#
# - CERT_DAYS: How long the random certificate is good for; defaults to 365
# - PROXY_URL: Where to send upstream requests; this is **required**
# - PROXY_PATH: Path exposed on the proxy, from which to call the service; this is **required** and must end in `/`

ENV CERT_CN=localhost
ENV PROXY_REDIRECT=default


# Image construction
# ------------------
#
# Just add OpenSSL, Nginx config, and our custom entrypoint.

RUN : &&\
    /sbin/apk update --quiet &&\
    /sbin/apk add --no-progress --quiet openssl &&\
    /bin/rm -rf /var/cache/apk/* &&\
    :
COPY etc/nginx.conf /etc/nginx/
COPY etc/default.conf.template /etc/nginx/templates/
COPY docker/entrypoint.sh /


# Entrypoint
# ----------
#
# Speaking of that custom entrypoint…

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]


# Metadata
# --------

EXPOSE 443
LABEL "org.label-schema.name"="ProxyCrypt"
LABEL "org.label-schema.description"="SSL/TLS termination for upstream services"
LABEL "org.label-schema.version"="1.0.0"
