FROM alpine
RUN apk --no-cache add \
	bash \
	util-linux \
	curl \
	jq
COPY lib /root/vsp
RUN ln -s /root/vsp/drv.core /usr/bin/vsp
RUN mkdir -p /cfg
ENV SDDCDIR "/cfg"
ENTRYPOINT ["vsp"]
