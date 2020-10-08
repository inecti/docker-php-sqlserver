# docker-php-sqlserver
Imagem criada para utilização no sistema de CCBS.


## Sobre
Surgiu a necessidade de diponibilizar um ambiente com algumas tecnologias especificas para a criação do sistema de CCBS.

## Tecnologias
A imagem contém Ubuntu 18.04, PHP 7.2 e suas bibliotecas, o gerenciador de pacotes composer e o CURL.

## Run

O comando para montar a imagem deverá ser executado no mesmo local do arquivo Dockerfile. O ponto no final significa que irá utilizar o Dockerfile da pasta em execução

~~~
$ docker build -t inec/php-sqlserver:1.0 .
~~~

Para montar o container executar o comando dentro da pasta do projeto.

~~~
$ docker run  -d  -p 3000:80 -v "$PWD":/var/www/html --name=CCBS inec/php-sqlserver:1.0
~~~


OBS.: O PWD siginifica que o volume será criado na pasta em que o comando está sendo executado ou seja a pasta doseu projeto, por exemplo var/www/html.
