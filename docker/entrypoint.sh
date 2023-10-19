#!/bin/sh -e
#
# 🕵️‍♀️ ProxyCrypt entrypoint — This is invoked at container startup.
#
# Copyright © 2023, California Institute of Technology ("Caltech").
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
#
# Check essential env vars:
: ${PROXY_URL:?✋ The environment variable PROXY_URL is required}

# "Reasonable" defaults:
CERT_CN=${CERT_CN:-localhost}
CERT_DAYS=${CERT_DAYS:-365}

echo "💁‍♀️ The CERT_CN is ${CERT_CN}" 1>&2

# Make a random self-signed certificate
/bin/rm -f /etc/ssl/self.key /etc/ssl/self.cert
/usr/bin/openssl req -nodes -x509 -days ${CERT_DAYS} -newkey rsa:2048 \
    -keyout /etc/ssl/self.key -out /etc/ssl/self.cert \
    -subj "/C=US/ST=California/L=Pasadena/O=Caltech/CN=${CERT_CN}"

# Turn things over to Nginx
exec /docker-entrypoint.sh "$@"
