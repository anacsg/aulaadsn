git add . &&
git commit -m $1 &&
git push --force -u origin master &&
ssh root@164.132.227.35 <<EOF
cd aulaadsn &&
git pull origin master &&
stack build &&
lsof -i:443 -Fp | sed 's/^p//' | head -n -1 | xargs kill -9;
nohup stack exec aulahaskell > /dev/null
echo "deploy finished"
EOF