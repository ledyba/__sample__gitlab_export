#!/bin/bash
#get these two values from your browsers request headers when you login to *your* gitlab website
cookie='Cookie: remember_user_token=BAhbB1sGaQdJIiIkMmEkMTAkNzJaZmpwWGxGcTJsdHlUVTcwZ0kuZQY6BkVU--1ca1a919555ab0fc4e4ca605c9ee51528c7441e9; path=/; expires=Sun, 11-Nov-2012 08:09:48 GMT; HttpOnly'
csrf='X-CSRF-Token: SWQ5OoY6/4d2DYLat0JJ2PAv1VQAppSCWZzxFVVfWZ0='
gitlab_host='ledyba.org' #substitute with IP if your server doesn't have a domain name

dir=`pwd`
for r in $(cat repos)
do
  repo=$(echo $r| cut -d':' -f 1)
  path=$(echo $r| cut -d':' -f 2)
  repo=$(echo "$repo" | sed -e "sZ/Z-Z")
  echo $repo
  echo $path
  curl -H "$cookie" -H "$csrf" -H "Requested-With: XMLHttpRequest" -d "project[name]=$repo&project[path]=$repo&project[code]=$repo&project[description]=$repo" -i "http://$gitlab_host/git/projects" > /dev/null
  cd $dir/$path
  git remote rm gitlab
  echo git remote add gitlab "git@$gitlab_host:$repo.git"
  git remote add gitlab "git@$gitlab_host:$repo.git"
  #git push gitlab master
  git push gitlab --all #comment out the above line and uncomment this one if you want to push all branches
done

