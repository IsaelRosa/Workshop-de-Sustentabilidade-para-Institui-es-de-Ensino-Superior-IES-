# SBWC Platform

Projeto de plataforma web para o 8º Simpósio Brasileiro sobre Wetlands Construídos (SBWC), com foco em:

- página institucional do evento
- inscrição e fluxo de pagamento
- submissão de artigos
- avaliação de trabalhos
- emissão e validação de certificados
- agenda e favoritos do participante

## Estrutura do projeto

- `index.html` — interface principal da plataforma
- `database/schema.sql` — estrutura do banco de dados MySQL
- `database/seed.sql` — dados iniciais para testes e homologação
- `database/hostinger.md` — instruções para deploy na Hostinger

## Deploy final para Hostinger

A documentação final de implantação está em [HOSTINGER_DEPLOY.md](./HOSTINGER_DEPLOY.md).

## Como usar localmente

1. Crie um arquivo `.env` a partir do `.env.example`.
2. Importe o esquema do banco MySQL local ou no Hostinger:

```bash
mysql -u usuario -p < database/schema.sql
```

3. Inicie a API:

```bash
npm install
npm run dev
```

4. Acesse `http://localhost:3000/api/health` para verificar o serviço.
5. Abra o `index.html` em um navegador para visualizar a interface.

## Configuração da API em produção

Se o frontend e a API estiverem em domínios diferentes, configure a URL da API antes do carregamento principal:

```html
<script>
  window.SBWC_API_BASE = 'https://api.seu-dominio.com/api';
</script>
```

Se a API estiver no mesmo domínio, pode manter `/api`.

## API Node.js

A API foi iniciada em `src/server.js` com endpoints básicos para:

- `GET /api/health`
- `GET /api/settings`
- `GET /api/agenda?day=1`
- `GET /api/proceedings`
- `GET /api/users`
- `POST /api/register`
- `POST /api/submission`
- `GET /api/submissions/:userId`
- `GET /api/certificates/:userId`
- `POST /api/certificates/validate`
- `POST /api/email-test`

## Banco de dados MySQL

Antes de publicar, importe o arquivo:

```bash
mysql -u usuario -p < database/schema.sql
```

## Próximo passo para GitHub

Depois de criar o repositório no GitHub, execute:

```bash
git remote add origin https://github.com/SEU_USUARIO/SEU_REPO.git
git branch -M main
git push -u origin main
```

## Observação

Este projeto atual está em formato estático (HTML + JavaScript). Para uso em produção com Hostinger, o ideal é separar:

- frontend em HTML/CSS/JS
- backend em PHP ou Node.js
- banco MySQL para persistência dos dados

---

## Modelo de dados principal

Inclui tabelas para:
- usuários
- inscrições
- submissões
- avaliadores
- certificados
- agenda
- e-mails transacionais
