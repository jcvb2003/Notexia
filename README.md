# Notexia

Editor de desenho e anotações em Flutter.

## Funcionalidades Principais

-   **Desenho Livre**: Ferramenta de lápis com performance otimizada (cache de Path).
-   **Formas Geométricas**: Retângulos, elipses, diamantes, setas e linhas.
-   **Texto**: Adição e edição de textos no canvas.
-   **Manipulação**: Mover, redimensionar, rotacionar e deletar elementos.
-   **Snap**: Alinhamento inteligente (angular e objetos).
-   **Zoom e Pan**: Navegação infinita no canvas.
-   **Undo/Redo**: Sistema robusto de desfazer/refazer via Command Pattern.
-   **Persistência**: Salvamento automático em banco de dados local (SQLite).

## Estrutura do Projeto

O projeto segue uma arquitetura baseada em Features (Vertical Slices) com Clean Architecture interna em cada feature.

-   `lib/src/features/`: Módulos funcionais (drawing, settings, etc).
-   `lib/src/core/`: Componentes e utilitários compartilhados.
-   `lib/src/app/`: Configuração global (temas, rotas, injeção de dependência).

## Como Rodar

1.  Instale as dependências:
    ```bash
    flutter pub get
    ```

2.  Execute o projeto:
    ```bash
    flutter run
    ```

## Testes

Para rodar os testes unitários e de widget:

```bash
flutter test; flutter analyze
```
