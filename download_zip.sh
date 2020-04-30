PROJECT_NAME=$1
URL=$2

if [[ -f $PROJECT_NAME/lib/lib$PROJECT_NAME.a ]]; then
	echo "$PROJECT_NAME/lib/lib$PROJECT_NAME.a Exist"
	exit 0
fi

if [[ ! $URL ]]; then
	URL_KEY="ytx_zipURL="
	URL=$(cat $PROJECT_NAME.podspec | grep "$URL_KEY" | sed -e "s/$URL_KEY//g" | sed -e "s/\'//g" | sed -e "s/\"//g")
fi

if [[ ! -d idealtemp ]]; then
	mkdir idealtemp
fi
cd idealtemp

RET=$(curl --fail -O -v $URL)
if [[ -f $PROJECT_NAME.zip && ! $RET ]]; then
	unzip $PROJECT_NAME.zip
	cp -fr $PROJECT_NAME/lib ../$PROJECT_NAME/
fi

cd ..
rm -fr idealtemp