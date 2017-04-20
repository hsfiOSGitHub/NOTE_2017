#! /bin/bash

CMD_PATH="$( dirname "$0" )"
cd "$CMD_PATH"
./jre/bin/java -XstartOnFirstThread  -Dfile.encoding=UTF-8 -jar ./RSA/alipay_rsa_sign_tools.jar 

