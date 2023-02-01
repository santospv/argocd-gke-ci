FROM alpine:3.5

RUN apk add --no-cache git curl

RUN cd /tmp/ \
        && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
        && curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.1.3/kustomize_v4.1.3_linux_amd64.tar.gz \
        && tar xzf ./kustomize_v4.1.3_linux_amd64.tar.gz \
        && rm kustomize_v4.1.3_linux_amd64.tar.gz \
        && cp kustomize kubectl /usr/local/bin/ \
        && chmod +x /usr/local/bin/kustomize \
        && chmod +x /usr/local/bin/kubectl

CMD ["/bin/sh"]