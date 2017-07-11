#!/bin/bash
##########################################################################
# Shellscript	:  	menu_backup.bash
# Function   	:  	Menu com diversas funcionalidades de Copia e Backup
# Version    	:  	3.0
# Author     	:  	Luciano Teixeira <luciano.teixeiras@gmail.com>
# Date       	:  	2017-07-01
# Requires   	:	Disciplina de Engenharia de Software
# Category   	:  	Useful Script
##########################################################################

#DECLARE

DATA_LOG=`date +%Y%m%d%H%M`
LOG=~/scripts/logs/backup_$DATA_LOG.log

#CRIANDO PASTA DE LOG SE NAO EXISTIR

DIRLOG=~/scripts/logs

if [ ! -d "$DIRLOG" ]; then
	mkdir ~/scripts;
	mkdir ~/scripts/logs;
fi

#IP REMOTO
IP=192.168.0.6

Principal() {
	while true; do
	clear
	echo "Menu de Controle:"
	echo
	echo "0. Gerar pacote de arquivos"
	echo "1. Transferencia benckmarks - SCP"
	echo "2. Transferencia benckmarks - SCP LOCAL"
	echo "3. Transferencia benckmarks - RSYNC"
	echo "4. Transferencia benckmarks - RSYNC LOCAL"
	echo "5. Delete benckmarks"
	echo "6. Delete benckmarks - REMOTO"
	echo "7. Sair do exemplo"
	echo
	echo "Escolha a Tarefa:"
	read opcao
		case $opcao in
			0) GERAR ;;
			1) SCP ;;
			2) SCPLOCAL ;;
			3) RSYNC ;;
			4) RSYNCLOCAL ;;
			5) DELETE ;;
			6) DELETEREMOTO ;;
			7) clear&&exit ;;
		esac
		echo "Pressione uma tecla para continuar..."
		read
	done
}

GERAR(){

#ALGORITMO DE CRIACAO DE CONTEUDO

echo "" > $LOG
echo "Iniciando LOG" >> $LOG
echo "============================================================" >> $LOG
linha=`date  +"Gerando os Arquivos - Inicio ...:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG
mkdir ~/benckmarks ;
mkdir ~/benckmarks/1 ;
mkdir ~/benckmarks/2 ;
mkdir ~/benckmarks/3 ;

#cria 1000 arquivos de tamanho aleatório
for counter in {1..1000} ;
do 
	dd if=/dev/urandom of=~/benckmarks/1/arquivo_$counter.rdm bs=$(($RANDOM % 100 + 1)) count=1000 ; 
done

#cria um arquivo de 100MB
dd if=/dev/urandom of=~/benckmarks/2/arquivo2.rdm bs=1M count=100 ;

#cria um arquivo de 1GB
dd if=/dev/urandom of=~/benckmarks/3/arquivo3.rdm bs=1M count=1000 ;

linha=`date  +"Gerando os Arquivos - Fim ......:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG

#ALGORITMO DE CONTAGEN

DIR=~/benckmarks

if ! [ $DIR ]
    then
    DIR='.'
fi

NUMARQ=0
NUMDIR=0
lista(){
for ARQ in $( ls $1/ )
  do
  [ -d "$1/$ARQ" ] && { NUMDIR=$(($NUMDIR+1)); lista $1/$ARQ; }
  [ -f "$1/$ARQ" ] && NUMARQ=$(($NUMARQ+1))
done
}
lista $DIR
echo "" >> $LOG
echo "Foram gerados $NUMARQ arquivos e $NUMDIR diretorios em '$DIR'." >> $LOG

}

SCP() {

echo "" >> $LOG
echo "============================================================" >> $LOG
linha=`date  +"SCP para Host Remoto - Inicio ...:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG
if [[ `whoami` == "root" ]];then
	echo "Realizando transferencia via scp..."
		scp -rp ~/benckmarks luciano@$IP:/home/luciano && echo "transferido com sucesso..."
else
	echo "É necessário ser o root para fazer transerencia"
fi

linha=`date  +"SCP para Host Remoto - Fim ......:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG

#ALGORITMO DE CONTAGEN

DIR=~/benckmarks

if ! [ $DIR ]
    then
    DIR='.'
fi

NUMARQ=0
NUMDIR=0
lista(){
for ARQ in $( ls $1/ )
  do
  [ -d "$1/$ARQ" ] && { NUMDIR=$(($NUMDIR+1)); lista $1/$ARQ; }
  [ -f "$1/$ARQ" ] && NUMARQ=$(($NUMARQ+1))
done
}
lista $DIR
echo "" >> $LOG
echo "SCP Enviados $NUMARQ arquivos e $NUMDIR diretorios em '$DIR'." >> $LOG

}

SCPLOCAL() {

echo "" >> $LOG
echo "============================================================" >> $LOG
linha=`date  +"SCP de Host Remoto - Inicio ...:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG
if [[ `whoami` == "root" ]];then
	echo "Realizando transferencia via scp..."
		scp -rp luciano@$IP:/home/luciano/benckmarks ~/ && echo "transferido com sucesso..."
else
	echo "É necessário ser o root para fazer transerencia"
fi

linha=`date  +"SCP de Host Remoto - Fim ......:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG

#ALGORITMO DE CONTAGEN

DIR=~/benckmarks

if ! [ $DIR ]
    then
    DIR='.'
fi

NUMARQ=0
NUMDIR=0
lista(){
for ARQ in $( ls $1/ )
  do
  [ -d "$1/$ARQ" ] && { NUMDIR=$(($NUMDIR+1)); lista $1/$ARQ; }
  [ -f "$1/$ARQ" ] && NUMARQ=$(($NUMARQ+1))
done
}
lista $DIR
echo "" >> $LOG
echo "SCP Recebidos $NUMARQ arquivos e $NUMDIR diretorios em '$DIR'." >> $LOG

}

RSYNC() {

echo "" >> $LOG
echo "============================================================" >> $LOG
linha=`date  +"RSYNC para Host Remoto - Inicio ...:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG

if [[ `whoami` == "root" ]];then
	echo "Realizando transferencia via scp..."
		rsync -CravzpuP ~/benckmarks luciano@$IP:/home/luciano && echo "transferido com sucesso..."
else
	echo "É necessário ser o root para fazer transerencia"
fi

linha=`date  +"RSYNC para Host Remoto - Fim ......:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG

#ALGORITMO DE CONTAGEN

DIR=~/benckmarks

if ! [ $DIR ]
    then
    DIR='.'
fi

NUMARQ=0
NUMDIR=0
lista(){
for ARQ in $( ls $1/ )
  do
  [ -d "$1/$ARQ" ] && { NUMDIR=$(($NUMDIR+1)); lista $1/$ARQ; }
  [ -f "$1/$ARQ" ] && NUMARQ=$(($NUMARQ+1))
done
}
lista $DIR
echo "" >> $LOG
echo "RSYNC Enviados $NUMARQ arquivos e $NUMDIR diretorios em '$DIR'." >> $LOG

}

RSYNCLOCAL() {

echo "" >> $LOG
echo "============================================================" >> $LOG
linha=`date  +"RSYNC de Host Remoto - Inicio ...:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG

if [[ `whoami` == "root" ]];then
	echo "Realizando transferencia via scp..."
		rsync -CravzpuP luciano@$IP:/home/luciano/benckmarks ~/ && echo "transferido com sucesso..."
else
	echo "É necessário ser o root para fazer transerencia"
fi

linha=`date  +"RSYNC de Host Remoto - Fim ......:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG

#ALGORITMO DE CONTAGEN

DIR=~/benckmarks

if ! [ $DIR ]
    then
    DIR='.'
fi

NUMARQ=0
NUMDIR=0
lista(){
for ARQ in $( ls $1/ )
  do
  [ -d "$1/$ARQ" ] && { NUMDIR=$(($NUMDIR+1)); lista $1/$ARQ; }
  [ -f "$1/$ARQ" ] && NUMARQ=$(($NUMARQ+1))
done
}
lista $DIR
echo "" >> $LOG
echo "RSYNC Recebidos $NUMARQ arquivos e $NUMDIR diretorios em '$DIR'." >> $LOG

}

DELETE() {

echo "" >> $LOG
echo "============================================================" >> $LOG
linha=`date  +"Delete ~/benckmarks Local - Inicio ...:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG

if [[ `whoami` == "root" ]];then
	echo "Realizando limpesa ..."
		rm -rf ~/benckmarks && echo "limpesa local com sucesso..."
else
	echo "É necessário ser o root para fazer limpesa"
fi

linha=`date  +"Delete ~/benckmarks Local - Fim ......:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG
}

DELETEREMOTO() {

echo "" >> $LOG
echo "============================================================" >> $LOG
linha=`date  +"Delete ~/benckmarks Remoto - Inicio ...:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG

if [[ `whoami` == "root" ]];then
	echo "Realizando limpesa ..."
		ssh luciano@$IP 'rm -rf ~/benckmarks'
else
	echo "É necessário ser o root para fazer limpesa"
fi

linha=`date  +"Delete ~/benckmarks Remoto - Fim ......:  %d/%m/%Y %H:%M:%S"`
echo "${linha}" >> $LOG
}

Principal
