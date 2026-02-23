---
name: php-development
description: |
  Guidelines para desenvolvimento PHP 8.x moderno. Ativar quando trabalhar com classes PHP,
  tipagem, enums, constructors, PHPDoc ou qualquer código PHP puro fora do contexto específico
  de frameworks.
---

# PHP Development

## Quando Ativar

Ative esta skill quando:

- Criar classes PHP genéricas
- Trabalhar com tipagem e type hints
- Definir enums
- Escrever PHPDoc blocks
- Refatorar código PHP

## Strict Types

Sempre use strict typing no início de arquivos `.php`:

```php
<?php

declare(strict_types=1);
```

## Control Structures

Sempre use chaves para estruturas de controle, mesmo para single-line:

```php
// Correto
if ($condition) {
    return true;
}

// Incorreto
if ($condition) return true;
```

## Constructors

Use constructor property promotion do PHP 8:

```php
// Correto
public function __construct(
    public readonly GitHub $github,
    private readonly Logger $logger,
) {}

// Incorreto - não permitir __construct() vazio sem parâmetros
// (exceto se o constructor for private)
```

## Type Declarations

- **Sempre** use return type declarations para métodos e funções.
- **Sempre** use type hints para parâmetros.

```php
protected function isAccessible(User $user, ?string $path = null): bool
{
    // ...
}
```

## Enums

- Keys em Enum devem ser **TitleCase**: `FavoritePerson`, `BestLake`, `Monthly`.
- Siga convenções existentes do projeto.

```php
enum OrderStatus: string
{
    case Pending = 'pending';
    case Processing = 'processing';
    case Completed = 'completed';
}
```

## Comments

- **Prefira PHPDoc blocks** sobre comentários inline.
- **Nunca** use comentários dentro do código, exceto se a lógica for excepcionalmente complexa.

## PHPDoc Blocks

Adicione array shape type definitions quando apropriado:

```php
/**
 * @param array{
 *     name: string,
 *     email: string,
 *     roles: list<string>
 * } $data
 * @return array{id: int, created: bool}
 */
public function createUser(array $data): array
{
    // ...
}
```

## Readonly Classes & Properties

Use `readonly` para DTOs e Value Objects:

```php
final readonly class UserData
{
    public function __construct(
        public string $name,
        public string $email,
        public ?string $phone = null,
    ) {}
}
```

## Final Classes

Prefira `final` para classes que não devem ser estendidas:

```php
final class CreateOrderAction
{
    public function execute(OrderData $data): Order
    {
        // ...
    }
}
```

## Erros Comuns

- Esquecer `declare(strict_types=1)`
- Não usar type hints em parâmetros e retornos
- Comentários inline desnecessários
- Enum keys em lowercase ou UPPERCASE ao invés de TitleCase
- Constructor vazio sem parâmetros (sem necessidade)
