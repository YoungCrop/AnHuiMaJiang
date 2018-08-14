rm -rf temp
rm -rf cryptores

mkdir temp
mkdir cryptores
mkdir cryptores/s

cp  config.json  temp
cp  project.manifest  temp
cp  version.manifest  temp

cp  -rf src_et  temp/src_et
cp  -rf res temp/res

./crypto -o -d -en -t -rd sfx -md5 temp cryptores ncmj@1235
./crypto -o -d -of mp3 -md5 temp cryptores/s

for filename in cryptores/s/* 
do
	mv $filename $filename.mp3 
done 

rm -rf temp
