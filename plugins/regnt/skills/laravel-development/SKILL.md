---
name: laravel-development
description: |
  Guidelines para desenvolvimento Laravel 12. Ativar quando criar controllers, models, migrations,
  Form Requests, policies, jobs, eventos, ou qualquer classe Laravel. Cobre convenções de database,
  Eloquent, validação, autenticação, filas e estrutura de arquivos do Laravel 12.
---

# Laravel Development

## Quando Ativar

Ative esta skill quando:

- Criar ou modificar controllers, models, migrations
- Trabalhar com Form Requests e validação
- Implementar autenticação ou autorização
- Criar jobs, eventos ou listeners
- Configurar rotas ou middleware

## Convenções Gerais

- Use comandos `php artisan make:*` para criar arquivos. Liste comandos disponíveis com `list-artisan-commands`.
- Passe `--no-interaction` para todos os comandos Artisan.
- Use `php artisan make:class` para classes PHP genéricas.

## Database & Eloquent

- Use métodos de relacionamento Eloquent com return type hints.
- Prefira Eloquent sobre queries raw ou joins manuais.
- **Evite `DB::`** - prefira `Model::query()`.
- Previna N+1 queries usando eager loading.
- Use query builder apenas para operações muito complexas.

### Criação de Models

Ao criar models, crie também factories e seeders úteis. Pergunte ao usuário se precisa de opções adicionais.

### APIs & Resources

Para APIs, use Eloquent API Resources e versionamento, a menos que as rotas existentes não sigam esse padrão.

## Controllers & Validação

- **Sempre** crie Form Request classes para validação - nunca validação inline no controller.
- Inclua regras de validação E mensagens de erro customizadas.
- Verifique Form Requests existentes para seguir o padrão (array ou string).

## Autenticação & Autorização

Use recursos nativos do Laravel: gates, policies, Sanctum.

## Geração de URLs

Prefira rotas nomeadas e a função `route()` para gerar links.

## Filas

Use jobs com `ShouldQueue` para operações demoradas.

## Configuração

- Use variáveis de ambiente **apenas** em arquivos de config.
- **Nunca** use `env()` fora de config files.
- Use `config('app.name')`, não `env('APP_NAME')`.

## Testes

- Use factories para criar models em testes.
- Verifique se a factory tem states customizados antes de configurar manualmente.
- Use `fake()->method()` ou `$this->faker->method()` seguindo convenção do projeto.
- Use `php artisan make:test {name}` para feature tests, `--unit` para unit tests.

## Laravel 12 - Estrutura

### Estrutura Streamlined (Laravel 11+)

- Middleware configurados em `bootstrap/app.php` com `Application::configure()->withMiddleware()`.
- `bootstrap/app.php` registra middleware, exceptions e arquivos de rotas.
- `bootstrap/providers.php` contém service providers da aplicação.
- Comandos em `app/Console/Commands/` são auto-registrados.
- **Não existe** `app/Console/Kernel.php` - use `bootstrap/app.php` ou `routes/console.php`.

### Database (Laravel 12)

- Ao modificar coluna, a migration deve incluir **todos** os atributos anteriores ou serão perdidos.
- Limitar eager loading nativamente: `$query->latest()->limit(10)`.

### Models (Laravel 12)

- Casts devem ser definidos no método `casts()`, não na propriedade `$casts`.

```php
protected function casts(): array
{
    return [
        'status' => OrderStatus::class,
        'metadata' => 'array',
    ];
}
```

## Comandos Artisan Úteis

```bash
php artisan make:model {name} -mfc    # Model + Migration + Factory + Controller
php artisan make:enum {name}          # Enum (Laravel 11+)
php artisan make:class {name}         # Classe PHP genérica
php artisan make:interface {name}     # Interface
```

## Erros Comuns

- Usar `env()` fora de arquivos de config
- Validação inline no controller ao invés de Form Request
- Esquecer eager loading causando N+1
- Não incluir todos atributos ao modificar coluna em migration
- Usar `$casts` property ao invés do método `casts()`
