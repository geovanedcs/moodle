# Moodle 4.0.12 no Coolify

Este compose foi preparado para a branch `moodle-4.0.12` (Build 20231211).

> **Aviso:** Moodle 4.0 e PHP 8.0 estão fora de suporte. Use apenas em
> ambiente isolado/de testes ou com uma estratégia explícita de mitigação
> e migração. Não exponha dados sensíveis sem atualizar a plataforma.

## Deploy

1. No Coolify, crie um novo recurso **Docker Compose** conectado ao GitHub
   `geovanedcs/moodle`, branch `moodle-4.0.12`.
2. Configure o caminho do Compose como `/compose.yaml` e habilite build
   a partir do Dockerfile (não selecione imagem pronta do Moodle).
3. Cadastre as variáveis de ambiente do recurso:
   - `MOODLE_URL=https://moodle.seudominio.com.br` (URL pública exata, sem barra final)
   - `DB_PASSWORD` (senha longa e aleatória)
   - `DB_ROOT_PASSWORD` (outra senha longa e aleatória)
4. No serviço **moodle** (porta interna 80), configure o domínio HTTPS
   correspondente a `MOODLE_URL` no Coolify. Não exponha a porta do banco.
5. Faça o deploy e abra o domínio para completar a instalação inicial.
   O arquivo `config.php` é gerenciado pela imagem e lê as variáveis.
6. Confirme o funcionamento do cron (serviço `cron`) após a instalação.

## Persistência e backups

Os volumes Docker `moodledata` e `dbdata` são persistentes. Configure
backups **dos dois volumes** (e restauração testada) antes de usar o sistema.
Atualizações da imagem não devem apagar esses volumes.

## Observações

- A configuração presume proxy HTTPS do Coolify; `$CFG->sslproxy = true`.
- Não comite senhas ou arquivos `.env` no repositório.
- O serviço cron pode registrar erros até o término da instalação inicial.
- Se a versão antiga exigir ajustes específicos de extensões, banco ou proxy,
  revise os logs de build e de execução antes de publicar.
