# Deploy na Hostinger com MySQL

## 1) Criar o banco de dados

No painel da Hostinger:

- acesse `MySQL Databases`
- crie um novo banco de dados
- crie um usuário com acesso ao banco
- grave os dados: host, username, password e nome do banco

## 2) Importar a estrutura

No phpMyAdmin da Hostinger, execute:

```sql
SOURCE database/schema.sql;
```

Ou importando o arquivo `schema.sql` pela interface.

## 3) Dados iniciais para testes

Importe também:

```sql
SOURCE database/seed.sql;
```

## 4) Conexão do projeto

Se estiver usando PHP, configure um arquivo `config.php` ou `.env` com algo como:

```php
<?php
$host = 'localhost';
$db   = 'sbwc_platform';
$user = 'usuario_db';
$pass = 'senha_db';
$charset = 'utf8mb4';
```

## 5) Publicação

- suba o projeto na pasta pública do Hostinger
- se for PHP, configure a página inicial corretamente
- se for estático, prefira um host com servidor back-end para consumir a API

## 6) Recomendação de arquitetura

Para um projeto de produção, é ideal:

- frontend: HTML/CSS/JS
- backend: PHP ou Node.js
- banco: MySQL
- upload de PDFs em pasta `uploads/`
- autenticação por sessão ou JWT
- API REST para inscrição, submissões e certificados

## 7) Workflow recomendado

- cadastro e login
- inscrição do participante
- submissão do artigo
- atribuição de parecerista
- parecer e aprovação/reprovação
- emissão do certificado
- validação por hash/QR

## 8) Observação importante

O arquivo `index.html` atual usa `localStorage`, ou seja, guarda os dados no navegador e não no banco. Para funcionar de forma real na Hostinger, a lógica precisa ser convertida para persistência em MySQL via backend.
