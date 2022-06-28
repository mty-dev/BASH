#!/bin/bash

action='status'

while [ $# -gt 0 ]; do
  case "$1" in
    --status)
      action='status'
      ;;
    --stop)
      action='stop'
      ;;
    --start)
      action='start'
      ;;
    --restart)
      action='restart'
      ;;
    --webmin)
      webmin="true"
      ;;
    --ldap)
      ldap="true"
      ;;
    --dns)
      dns="true"
      ;;
    --httpd)
      httpd="true"
      ;;
    --sys)
      webmin="true"
      ldap="true"
      dns="true"
      httpd="true"
      ;;
    --gitlab)
      gitlab="true"
      ;;
    --gitlabservice)
      gitlab="true"
      gitlabservice="true"
      ;;
    --sonar)
      sonar="true"
      ;;
    --postgresql)
      sonar="true"
      postgresql="true"
      ;;
    --jenkins)
      jenkins="true"
      ;;
    --nexus)
      nexus="true"
      ;;
    --cicd)
      gitlab="true"
      sonar="true"
      postgresql="true"
      jenkins="true"
      nexus="true"
      ;;
    --all)
      gitlab="true"
      gitlabservice="true"
      sonar="true"
      postgresql="true"
      jenkins="true"
      nexus="true"
      ldap="true"
      dns="true"
      httpd="true"
      webmin="true"
      ;;
    --help)
      echo "
Zarządzanie serwisami

Składnia:
    ./server.sh [lista serwisów] [--status|--stop|--start|--restart]

Serwis:
    --webmin
    --ldap
    --dns
    --httpd
    --sys           WSZYSTKIE w tej grupie

    --gitlab
    --gitlabservice
    --sonar
    --postgresql    postgresql + sonar
    --jenkins
    --nexus
    --cicd          WSZYSTKIE w tej grupie

    --all           WSZYSTKIE

Akcja:
    --status        [default]
    --stop
    --start
    --restart

    --help              pomoc
"
      exit 0
      ;;
    *)
      echo "Nieznany argument: ${1}" >&2
      exit 1
  esac
  shift
done



[[ -n "$gitlab" ]]        && echo "==> GitLab - $action"         && /bin/gitlab-ctl $action
[[ -n "$gitlabservice" ]] && echo "==> GitLabService - $action"  && /bin/systemctl  $action gitlab-runsvdir
[[ -n "$jenkins" ]]       && echo "==> Jenkins - $action"        && /bin/systemctl  $action jenkins
[[ -n "$nexus" ]]         && echo "==> Nexus - $action"          && /bin/systemctl  $action nexus
[[ -n "$dns" ]]           && echo "==> DNS - $action"            && /bin/systemctl  $action named
[[ -n "$httpd" ]]         && echo "==> httpd - $action"          && /bin/systemctl  $action httpd
[[ -n "$webmin" ]]        && echo "==> webmin - $action"         && /bin/systemctl  $action webmin


[[ -n "$ldap" ]]      && echo "==> ldap - $action"
if [[ -n "$ldap" && "$action" == "status" ]]; then
    /bin/docker ps | grep ldap | grep -v grep
elif [[ -n "$ldap" && "$action" == "stop" ]]; then
    cd /root/config/ldap && /usr/local/bin/docker-compose stop && cd -
elif [[ -n "$ldap" && "$action" == "start" ]]; then
    cd ~/config/ldap && /usr/local/bin/docker-compose up --detach && cd -
fi

[[ -n "$sonar" ]]       && echo "==> sonarQube - $action"
[[ -n "$postgresql" ]]  && echo "==> Postgresql - $action"
if [[ "$action" == "status" ]]; then
    [[ -n "$sonar" ]]       && /bin/systemctl $action sonarqube
    [[ -n "$postgresql" ]]  && /bin/systemctl $action postgresql-12
elif [[ "$action" == "stop" ]]; then
    [[ -n "$sonar" ]]       && /bin/systemctl $action sonarqube
    [[ -n "$postgresql" ]]  && /bin/systemctl $action postgresql-12
elif [[ "$action" == "start" ]]; then
    [[ -n "$postgresql" ]]  && /bin/systemctl $action postgresql-12
    [[ -n "$sonar" ]]       && /bin/systemctl $action sonarqube
elif [[ "$action" == "restart" ]]; then
    [[ -n "$sonar" ]]       && /bin/systemctl stop sonarqube
    [[ -n "$postgresql" ]]  && /bin/systemctl $action postgresql-12
    [[ -n "$sonar" ]]       && /bin/systemctl start sonarqube
fi
