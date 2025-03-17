FROM buildpack-deps:xenial-scm

MAINTAINER Dmitry Ustalov <dmitry.ustalov@gmail.com>

RUN \
apt-get update && \
apt-get install -y -o Dpkg::Options::="--force-confold" --no-install-recommends build-essential cmake unzip lua5.2 && \
apt-get install -y openjdk-8-jdk && \
apt-get install -y default-jdk && \
apt-get clean && \
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 && \
rm -rf /var/lib/apt/lists/*

RUN \
git clone 'https://github.com/JsJustS/tomita-parser.git' tomita && \
mkdir -p /tomita/build && \
cd /tomita/build && \
cmake ../src/ -DMAKE_ONLY=FactExtract/Parser/tomita-parser -DCMAKE_BUILD_TYPE=Release && \
make -j2 && \
mv /tomita/build/FactExtract/Parser/tomita-parser/tomita-parser /tomita/parser && \
cp /tomita/build/FactExtract/Parser/textminerlib_java/libFactExtract-Parser-textminerlib_java.so /usr/lib
#rm -rf /tomita/.git /tomita/src /tomita/build

RUN \
curl -sL -O 'https://github.com/yandex/tomita-parser/releases/download/v1.0/libmystem_c_binding.so.linux_x64.zip' && \
unzip /libmystem_c_binding.so.linux_x64.zip && \
mv -f /libmystem_c_binding.so /tomita/libmystem_c_binding.so && \
cp /tomita/build/libmystem_c_binding.so /usr/lib && \
rm -f /libmystem_c_binding.so.linux_x64.zip && \
chmod +x /tomita/libmystem_c_binding.so && \
ln -s /tomita/parser /usr/bin/tomita-parser
