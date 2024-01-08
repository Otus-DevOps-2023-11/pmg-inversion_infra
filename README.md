# pmg-inversion_infra
pmg-inversion Infra repository

## ДЗ - 3
### Знакомство с облачной инфраструктурой Yandex.Cloud

### Виртуальные машины
> local machine -> bastion -> someinternalhost

```
bastion_IP = 51.250.8.213
someinternalhost_IP = 10.128.0.7
```

### Подключение к `someinternalhost` в одну строку
***(через промежуточный bastion)***

`ssh -t -i ~/.ssh/appuser -A appuser@51.250.8.213 ssh appuser@10.128.0.7`

### Подключение к someinternalhost командой `ssh someinternalhost`
***(через промежуточный bastion)***

В файле `~/.ssh/config` добавить:
```
Host bastion
    HostName 51.250.8.213
    User appuser
    IdentityFile ~/.ssh/appuser

Host someinternalhost
    HostName 10.128.0.7
    User appuser
    IdentityFile ~/.ssh/appuser
    ProxyCommand ssh bastion nc %h %p
```

> Кстати, на бастион после такой настройки заходить также: `ssh bastion`

### VPN сервер
**Pritunl**
Веб-морда:
https://51.250.8.213/#/dashboard

Процесс настройки:
1. организация
2. пользователь
3. сервер

> После конфигурирования VPN сервера скачивается файл *.ovpn из веб морды.

Теперь подключение к внутреннему серверу с локальной машины возможен напрямую:
`ssh -i ~/.ssh/appuser appuser@10.128.0.7`

> Также, теперь можно добавить в `~/.ssh/config` следующие строчки:
> ```
> Host someinternalhost_vpn
>    HostName 10.128.0.7
>    User appuser
>    IdentityFile ~/.ssh/appuser
> ```
> и тогда подключение после поднятого vpn возможно напрямую:
> `ssh someinternalhost_vpn`
> *Отличие такого способа от описанного выше варианта заключается в том, что мы не указываем `ProxyCommand` в настройках ssh – данную функцию уже берёт на себя поднятое vpn подключение*

 ***Сейчас веб-интерфейс VPN-сервера Pritunl работает с самоподписанным сертификатом. И браузер постоянно ругается на это.***

 Решить эту проблему можно при помощи сервиса nip.io:
 Добавить домен вида `51-250-8-213.nip.io`

 ### Состав файлов задания
```
 /vpn/cloud-bastion.ovpn
 /vpn/setupvpn.sh
 /vpn/ssh-config   # конфиг из ~/.ssh/config
```

## ДЗ - 4
### Деплой тестового приложения

#### Виртуальные машины
> local machine -> testapp

#### Основное задание
```
testapp_IP = 130.193.39.107
testapp_port = 9292
```

#### Дополнительное задание
> В качестве доп. задания используйте созданные ранее скрипты для создания `startup script`, который будет запускаться при создании инстанса.

Реализовано два варианта:
- Запуск на основе последовательных shell скриптов: `create-instance-by-shell.sh`
- Запуск на основе декларативного указания пакетов: `create-instance-by-package.sh`

## ДЗ - 5
### Сборка образов VM при помощи Packer

#### Равзертывание образа
http://158.160.5.85:9292

#### Построение bake-образа
`immutable.json` и вся его обвязка
