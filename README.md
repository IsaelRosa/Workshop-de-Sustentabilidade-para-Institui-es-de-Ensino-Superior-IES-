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

## Como usar localmente

1. Abra o `index.html` em um navegador para visualizar a interface.
2. Para integrar com banco de dados, o ideal é converter a lógica atual em uma API PHP ou Node.js conectada ao MySQL.
3. Importar o esquema em um banco MySQL local ou na Hostinger.

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
