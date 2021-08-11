FROM lambci/lambda:build-python3.8

# Based on https://aws.amazon.com/premiumsupport/knowledge-center/lambda-linux-binary-package/

# TODO: Conflict between fontconfig and gdk-pixbuf2 results in error on dev:
# cannot load library 'libfontconfig.so.1': /opt/lib/libgio-2.0.so.0: undefined symbol: g_free

RUN yum install -y yum-utils rpmdevtools
WORKDIR /tmp
RUN yumdownloader \
    libffi pixman fontconfig freetype libglvnd libglvnd-glx libglvnd-egl mesa-libglapi libpng libxcb \
    libXrender libX11 libXext libXau libXdamage libXfixes libXxf86vm expat libuuid libxshmfence \
    libdrm libwayland-client libwayland-server glib2 fribidi libthai harfbuzz graphite2 gdk-pixbuf2 \
    cairo pango
RUN rpmdev-extract *rpm

RUN mkdir /opt/lib
WORKDIR /opt/lib
RUN cp -P -R /tmp/*/usr/lib64/* /opt/lib
RUN ln libpango-1.0.so.0 pango-1.0 && \
    ln libpangocairo-1.0.so.0 pangocairo-1.0
WORKDIR /opt
RUN zip weasyprint_lambda_layer.zip lib/*