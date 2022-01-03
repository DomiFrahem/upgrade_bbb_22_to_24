# Upgrade BigBlueButton 2.2 to 2.4

###### Удалить полность BigBlueButton
``
./script.sh -D
``
###### Вызов помощи
``
./script.sh -h
``
## Обновление BigBlueButton и ОС
###### Первая стадия
> Удаляет полность BigBlueButton и обновляет до Ubuntu 18.04<br />
``
./script.sh -S 1
``
###### Вторая стадия
> Обновляет репозитори, обновляет пакеты и перегружает систему <br />
``
./script.sh -S 2
``
###### Третия стадия
> Установка BigBlueButton <br />
``
./script.sh -S 3 -s example.mydomain.com -e exmaple@domain.com -v bionic-240 -g 
``<br />
**-s** -- Домен<br />
**-e** -- Email: Default = exmaple@domain.com<br />
**-v** -- Версия BigBlueButton: Default = bionic-240<br />
**-g** -- Устанавить greenlight<br />
