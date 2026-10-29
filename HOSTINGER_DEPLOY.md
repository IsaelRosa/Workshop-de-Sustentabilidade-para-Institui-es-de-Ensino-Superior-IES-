# Deploy final para Hostinger

Este documento reúne a configuração final recomendada para publicar a plataforma SBWC na Hostinger com MySQL e API Node.js.

## 1) Arquitetura recomendada

A arquitetura mais segura para a Hostinger é:

- Frontend: site estático ou app local em HTML/CSS/JS
- Backend API: Node.js + Express
- Banco: MySQL da Hostinger
- Variáveis de ambiente: `.env` com dados confidenciais

Observação importante: o Hostinger muitas vezes serve o site como hosting estático, e isso não executa uma aplicação Node automaticamente. Se o plano for apenas hosting estático, a API precisa ficar em outro domínio/subdomínio com Node habilitado.

## 2) Arquivo de ambiente final

Crie/ajuste o arquivo `.env` com esta estrutura:

```env
PORT=3000
NODE_ENV=production
DB_HOST=localhost
DB_PORT=3306
DB_USER=u315093330_Simposio
DB_PASSWORD=SuaSenhaCorretaAqui
DB_NAME=u315093330_Simposio
ALLOWED_ORIGINS=https://lightcoral-lemur-984907.hostingersite.com
```

Se a API estiver em subdomínio dedicado, use:

```env
ALLOWED_ORIGINS=https://api.seu-dominio.com,https://lightcoral-lemur-984907.hostingersite.com
```

## 3) Configuração da API Node

No painel da Hostinger, se houver suporte para Node.js, configure:

- Startup command: `npm install --production && npm start`
- Port: `3000`
- Working directory: pasta do projeto

O arquivo principal do backend já está em:

- `src/server.js`
- `src/db.js`

A aplicação expõe os endpoints em `/api`, por exemplo:

- `GET /api/health`
- `GET /api/settings`
- `GET /api/agenda?day=1`
- `GET /api/proceedings`
- `POST /api/register`
- `POST /api/submission`

## 4) Verificação do banco

Teste a API via:

```bash
curl https://seu-dominio.com/api/health
```

Resposta esperada:

```json
{"ok":true,"message":"SBWC API online","database":"connected","dbHost":"localhost","dbName":"u315093330_Simposio","databaseError":null}
```

Se o retorno mostrar `database:"offline"` ou `Access denied`, revise:

- usuário MySQL correto
- senha correta
- nome do banco correto
- host correto (`localhost` na Hostinger em muitos casos)

## 5) Configuração do frontend

O front-end já está preparado para usar a API via `window.SBWC_API_BASE`.

Se a API estiver no mesmo domínio, pode deixar como padrão:

```html
<script>
  window.SBWC_API_BASE = '/api';
</script>
```

Se a API estiver em subdomínio, configure assim:

```html
<script>
  window.SBWC_API_BASE = 'https://api.seu-dominio.com/api';
</script>
```

No projeto atual, a lógica já existe em `index.html`:

```js
const configuredApiBase = typeof window !== 'undefined' && window.SBWC_API_BASE
    ? window.SBWC_API_BASE.replace(/\/$/, '')
    : null;

const API_BASE = configuredApiBase || (
    (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1')
        ? 'http://localhost:3000/api'
        : '/api'
);
```

## 6) Se o plano da Hostinger for apenas hosting estático

Quando o painel da Hostinger só expõe pasta pública estática, a API não vai funcionar na raiz do domínio. Neste caso, o ideal é:

1. manter o frontend na pasta pública do site
2. mover a API para um subdomínio com Node habilitado
3. apontar o frontend para esse subdomínio

Exemplo:

```html
<script>
  window.SBWC_API_BASE = 'https://api.lightcoral-lemur-984907.hostingersite.com/api';
</script>
```

## 7) Checklist final de publicação

- [ ] Atualizar `.env` com valores reais do banco
- [ ] Confirmar a senha do usuário MySQL
- [ ] Importar `database/schema.sql` no MySQL da Hostinger
- [ ] Importar `database/seed.sql` (opcional)
- [ ] Rodar `npm install --production`
- [ ] Confirmar `npm start` funciona
- [ ] Acessar `https://seu-dominio.com/api/health`
- [ ] Verificar se a raiz do site carrega o HTML
- [ ] Ajustar `window.SBWC_API_BASE` se a API for externa

## 8) Observação final

O que foi validado no projeto é que a API e o MySQL conseguem funcionar corretamente quando a aplicação Node está sendo executada em ambiente adequado. O problema principal de deploy na Hostinger é a diferença entre:

- hosting estático
- hosting com aplicação Node

Se a Hostinger não tiver runtime Node no domínio atual, o deploy real precisa ser feito em app separate/subdomain.
