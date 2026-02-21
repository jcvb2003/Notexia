# Regras Operacionais (Top 5 Unbreakable Rules)

Este documento contém as 5 regras de ouro absolutas para o desenvolvimento e evolução do projeto **Notexia**. O descumprimento destas regras resultará em dívida técnica e regressão arquitetural.

Estas regras substituem os antigos documentos de arquitetura, que foram movidos para o arquivo (`.planejamento/`) apenas para registro histórico (ADR).

---

## 1. Arquitetura Plana e Direta (Adeus "Scopes" e Intermediários)
Evite abstrações redundantes. Não crie classes proxy puras (como os antigos `SelectionScope`, `ViewportScope` ou `ManipulationScope`) cujo único papel é repassar chamadas e emitir estado. O `CanvasCubit` deve gerenciar a lógia de interação com o Canvas diretamente através de métodos próprios bem definidos ou via delegates puros que não mantenham estado do Cubit. 

## 2. Tratamento Consistente de Erros (`Result<T>`)
Qualquer operação que possa falhar (I/O, parsing de arquivos, operações assíncronas de gravação) DEVE retornar um `Result<T>` ou uma subclassificação de `Result` (como `Success` e `Failure`). 
* **Nunca lance exceções (`throw`) como mecanismo de controle de fluxo de negócio**.
* Proteja as fronteiras (Repositories, Services) garantindo que as falhas sejam encapsuladas em blocos `try-catch` e transformadas em `Result.failure()`.

## 3. UI Consome o Cubit Diretamente
Os widgets da Interface de Usuário (Appbars, Toolbars, GestureHandlers) devem chamar os métodos do `CanvasCubit` de forma direta (ex: `cubit.selectElement()`). Não devem existir "wrappers" ou camadas de tradução de interação entre a UI e o Cubit. Se uma ação for executada via tecla de atalho ou clique, ela vai direto para o Cubit (ou para um Command).

## 4. Evite Estrutura de Pastas Profunda e Desnecessária
Mantenha a árvore de diretórios do projeto o mais horizontal possível. Não crie níveis profundos de subpastas a menos que haja um ganho real de encapsulamento para aquela sub-feature específica. Agrupar por funcionalidade (feature-based) é o padrão, mas não adicione subcamadas em excesso dentro de uma feature (`layer1/layer2/layer3/widget.dart`).

## 5. Menos é Mais (Código Sobre Engenharia)
Prefira código simples, legível e direto à "sobre-engenharia" preditiva. Se houver apenas uma implementação de uma classe ou comportamento, não crie Interfaces (`abstract class` ou `implements`) antecipadamente. Faça o código funcionar resolvendo o problema atual. Se a necessidade de abstração surgir no futuro para suportar um novo requisito, refatore no momento oportuno.
