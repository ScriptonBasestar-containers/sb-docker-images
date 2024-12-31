# Jenkins - Docker

수동으로 빌드배포

## 로컬 실행

```bash
docker compose up
```

## 플러그인 목록 가져오기

- https://stackoverflow.com/questions/9815273/how-to-get-a-list-of-installed-jenkins-plugins-with-name-and-version-pair
- http://localhost:8080/manage/script

```groovy
Jenkins.instance.pluginManager.plugins.each{
  plugin -> 
    println ("${plugin.getDisplayName()} (${plugin.getShortName()}): ${plugin.getVersion()}")
}

Jenkins.instance.pluginManager.plugins.each {
    println "${it.shortName}:${it.version}"
}

Jenkins.instance.pluginManager.plugins.each {
    println "${it.shortName}"
}
```

## Build push

- make jenkins-buid
- make jenkins-tag
- make jenkins-push

## Ref

- https://github.com/jenkinsci/docker
