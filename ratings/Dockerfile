# Copyright Istio Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM harbor.dev.21vianet.com/bookinfo/node:12.18.1-slim

COPY package.json /opt/microservices/
COPY ratings.js /opt/microservices/
WORKDIR /opt/microservices
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install

#hadolint ignore=DL3008
#RUN apt-get update
#RUN apt-get install curl --no-install-recommends -y \
#    && rm -rf /var/lib/apt/lists/*

ARG service_version
ENV SERVICE_VERSION ${service_version:-v1}

EXPOSE 9080
CMD ["node", "/opt/microservices/ratings.js", "9080"]
