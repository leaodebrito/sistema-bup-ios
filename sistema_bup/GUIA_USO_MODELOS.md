# Guia de Uso - Modelos de Dados e Services

Este guia explica como usar os modelos de dados e funções implementados para acessar as informações dos estudos de viabilidade.

## 📦 Estrutura Criada

### 1. Modelos de Dados (`Projeto.swift`)

Todos os modelos de dados foram implementados seguindo a estrutura documentada em `ESTRUTURA_DADOS.md`:

- **Projeto**: Documento principal com informações do projeto
- **AnaliseTerreno**: Análise de precificação do terreno
- **AnaliseMercado**: Análise do mercado imobiliário
- **AnaliseEspacoSolucoes**: Análise de soluções arquitetônicas possíveis
- **AnaliseViabilidade**: Análise detalhada de viabilidade econômica

### 2. Services

#### **FirestoreService** (`FirestoreService.swift`)
Service de baixo nível para comunicação direta com o Firestore.

#### **AnalysisService** (`AnalysisService.swift`)
Service de alto nível com funções convenientes para acessar análises.

---

## 🚀 Como Usar

### 1. Buscar Projetos

```swift
import SwiftUI

struct ExemploListaProjetos: View {
    @State private var projetos: [Projeto] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        List(projetos) { projeto in
            VStack(alignment: .leading) {
                Text(projeto.nomeProjeto)
                    .font(.headline)
                Text(projeto.nomeCliente)
                    .font(.subheadline)
            }
        }
        .task {
            await carregarProjetos()
        }
    }

    func carregarProjetos() async {
        isLoading = true
        defer { isLoading = false }

        do {
            projetos = try await FirestoreService.shared.fetchProjetos()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

### 2. Buscar Análises de um Projeto

#### Buscar Análise de Terreno

```swift
// Buscar versão mais recente
let analiseTerreno = try await AnalysisService.shared.getAnaliseTerreno(
    projetoId: "ABC123XYZ"
)

if let analise = analiseTerreno {
    print("Valor estimado: R$ \(analise.precificacaoTerreno.valorTotalEstimado ?? 0)")
    print("Valor por m²: R$ \(analise.precificacaoTerreno.valorM2Estimado ?? 0)")
}

// Buscar versão específica
let analiseV2 = try await AnalysisService.shared.getAnaliseTerreno(
    projetoId: "ABC123XYZ",
    versao: "2.0"
)

// Buscar todas as versões
let todasVersoes = try await AnalysisService.shared.getAllAnalisesTerrenoVersions(
    projetoId: "ABC123XYZ"
)
```

#### Buscar Análise de Mercado

```swift
let analiseMercado = try await AnalysisService.shared.getAnaliseMercado(
    projetoId: "ABC123XYZ"
)

if let analise = analiseMercado {
    print("Preço médio m²: R$ \(analise.precificacaoImovel.valorReferenciaM2 ?? 0)")

    if let conclusoes = analise.conclusoesEstudo {
        print("Demanda alta: \(conclusoes.demandaAlta ?? false)")
        print("Recomendação: \(conclusoes.recomendacao ?? "")")
    }
}
```

#### Buscar Análise de Viabilidade

```swift
let analiseViabilidade = try await AnalysisService.shared.getAnaliseViabilidade(
    projetoId: "ABC123XYZ"
)

if let analise = analiseViabilidade {
    // Verificar se é viável
    if let parecer = analise.parecerViabilidade {
        print("Projeto viável: \(parecer.viavel ?? false)")
        print("Nível de risco: \(parecer.nivelRisco ?? "N/A")")
        print("Recomendação: \(parecer.recomendacao ?? "")")
    }

    // Ver melhor solução
    if let melhorSolucao = analise.visaoGeral?.melhorSolucao {
        print("ID da melhor solução: \(melhorSolucao.id)")
        print("Lucro: R$ \(melhorSolucao.lucro ?? 0)")
        print("Margem: \(melhorSolucao.margem ?? 0)%")
    }

    // Ver todas as soluções viáveis
    if let solucoes = analise.solucoesViaveis {
        for solucao in solucoes {
            print("Solução \(solucao.id):")
            print("  Pavimentos: \(solucao.configuracao?.numPavimentos ?? 0)")
            print("  Total unidades: \(solucao.configuracao?.totalUnidades ?? 0)")
            print("  Lucro: R$ \(solucao.metricasEconomicas?.lucro ?? 0)")
        }
    }
}
```

### 3. Buscar Todas as Análises de Uma Vez

```swift
let analises = try await AnalysisService.shared.getTodasAnalises(
    projetoId: "ABC123XYZ"
)

// Verificar se tem análises
if analises.hasAnalyses {
    print("Projeto tem pelo menos uma análise")
}

// Verificar se está completo
if analises.isComplete {
    print("Projeto tem todas as análises principais")
}

// Acessar cada análise
if let terreno = analises.terreno {
    print("Valor do terreno: R$ \(terreno.precificacaoTerreno.valorTotalEstimado ?? 0)")
}

if let mercado = analises.mercado {
    print("Preço m²: R$ \(mercado.precificacaoImovel.valorReferenciaM2 ?? 0)")
}

if let espacoSolucoes = analises.espacoSolucoes {
    print("Taxa de viabilidade: \(espacoSolucoes.metricasViabilidade.taxaViabilidade ?? 0)")
}

if let viabilidade = analises.viabilidade {
    print("Projeto viável: \(viabilidade.parecerViabilidade?.viavel ?? false)")
}
```

### 4. Usar Funções Helper Convenientes

```swift
// Obter apenas o valor estimado do terreno
let valorTerreno = try await AnalysisService.shared.getValorEstimadoTerreno(
    projetoId: "ABC123XYZ"
)

// Obter preço de referência do m²
let precoM2 = try await AnalysisService.shared.getPrecoReferenciaM2(
    projetoId: "ABC123XYZ"
)

// Obter a melhor solução viável completa
let melhorSolucao = try await AnalysisService.shared.getMelhorSolucao(
    projetoId: "ABC123XYZ"
)

if let solucao = melhorSolucao {
    print("Melhor configuração:")
    print("  Pavimentos: \(solucao.configuracao?.numPavimentos ?? 0)")
    print("  Unidades: \(solucao.configuracao?.totalUnidades ?? 0)")
    print("  Área útil: \(solucao.configuracao?.areaUtilUnidade ?? 0) m²")
    print("  VGV: R$ \(solucao.metricasEconomicas?.vgv ?? 0)")
    print("  Custo: R$ \(solucao.metricasEconomicas?.custoTotal ?? 0)")
    print("  Lucro: R$ \(solucao.metricasEconomicas?.lucro ?? 0)")
    print("  Margem: \(solucao.metricasEconomicas?.margem ?? 0)%")
}

// Obter resumo consolidado do projeto
let resumo = try await AnalysisService.shared.getResumoConsolidado(
    projetoId: "ABC123XYZ"
)

if let resumo = resumo {
    print("📊 Resumo do Projeto:")
    print("Terreno: R$ \(resumo.valorEstimadoTerreno ?? 0)")
    print("Preço m²: R$ \(resumo.precoReferenciaM2 ?? 0)")
    print("Soluções viáveis: \(resumo.solucoesViaveis ?? 0)")
    print("Melhor lucro: R$ \(resumo.melhorLucro ?? 0)")
    print("Melhor margem: \(resumo.melhorMargem ?? 0)%")
    print("Viável: \(resumo.isViavel ?? false)")
    print("Risco: \(resumo.nivelRisco ?? "N/A")")
}
```

### 5. Exemplo Completo em uma View

```swift
import SwiftUI

struct ProjetoDetailAnalysisView: View {
    let projetoId: String

    @State private var resumo: ResumoConsolidado?
    @State private var melhorSolucao: SolucaoViavel?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isLoading {
                    ProgressView("Carregando análises...")
                } else if let error = errorMessage {
                    Text("Erro: \(error)")
                        .foregroundColor(.red)
                } else {
                    // Resumo Geral
                    if let resumo = resumo {
                        ResumoSection(resumo: resumo)
                    }

                    // Melhor Solução
                    if let solucao = melhorSolucao {
                        MelhorSolucaoSection(solucao: solucao)
                    }
                }
            }
            .padding()
        }
        .task {
            await carregarAnalises()
        }
    }

    func carregarAnalises() async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let resumoTask = AnalysisService.shared.getResumoConsolidado(
                projetoId: projetoId
            )
            async let solucaoTask = AnalysisService.shared.getMelhorSolucao(
                projetoId: projetoId
            )

            resumo = try await resumoTask
            melhorSolucao = try await solucaoTask
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct ResumoSection: View {
    let resumo: ResumoConsolidado

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Resumo da Viabilidade")
                .font(.headline)

            if let viavel = resumo.isViavel {
                HStack {
                    Text("Status:")
                    Text(viavel ? "✅ Viável" : "❌ Inviável")
                        .foregroundColor(viavel ? .green : .red)
                }
            }

            if let risco = resumo.nivelRisco {
                Text("Risco: \(risco)")
            }

            if let lucro = resumo.melhorLucro {
                Text("Melhor Lucro: R$ \(lucro, specifier: "%.2f")")
            }

            if let margem = resumo.melhorMargem {
                Text("Melhor Margem: \(margem, specifier: "%.2f")%")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct MelhorSolucaoSection: View {
    let solucao: SolucaoViavel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Melhor Solução: \(solucao.id)")
                .font(.headline)

            if let config = solucao.configuracao {
                Text("Pavimentos: \(config.numPavimentos ?? 0)")
                Text("Unidades: \(config.totalUnidades ?? 0)")
                Text("Área útil: \(config.areaUtilUnidade ?? 0, specifier: "%.2f") m²")
            }

            if let metricas = solucao.metricasEconomicas {
                Divider()
                Text("VGV: R$ \(metricas.vgv ?? 0, specifier: "%.2f")")
                Text("Custo Total: R$ \(metricas.custoTotal ?? 0, specifier: "%.2f")")
                Text("Lucro: R$ \(metricas.lucro ?? 0, specifier: "%.2f")")
                Text("Margem: \(metricas.margem ?? 0, specifier: "%.2f")%")
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}
```

---

## 📝 Notas Importantes

### Tratamento de Erros

Sempre use `do-catch` ao chamar funções assíncronas:

```swift
do {
    let analise = try await AnalysisService.shared.getAnaliseViabilidade(
        projetoId: projetoId
    )
    // Processar analise
} catch FirestoreError.analiseNaoEncontrada {
    print("Análise não encontrada")
} catch FirestoreError.projetoNaoEncontrado {
    print("Projeto não encontrado")
} catch {
    print("Erro desconhecido: \(error)")
}
```

### Valores Opcionais

Muitos campos dos modelos são opcionais (`?`). Sempre verifique se existem antes de usar:

```swift
if let valorTerreno = analise.precificacaoTerreno.valorTotalEstimado {
    print("Valor: R$ \(valorTerreno)")
} else {
    print("Valor não disponível")
}
```

### Versionamento

As subcoleções usam versionamento (1.0, 2.0, 3.0):
- Use `get...` para obter a versão mais recente
- Use `get...(versao:)` para versão específica
- Use `getAll...Versions()` para todas as versões

---

## 🎯 Casos de Uso Comuns

### 1. Dashboard com Indicadores Principais
```swift
let resumo = try await AnalysisService.shared.getResumoConsolidado(projetoId: id)
// Exibir cards com: viabilidade, lucro, margem, risco
```

### 2. Comparar Soluções Viáveis
```swift
let analise = try await AnalysisService.shared.getAnaliseViabilidade(projetoId: id)
if let solucoes = analise.solucoesViaveis {
    // Ordenar por lucro, margem, VPL, etc.
    let ordenadasPorLucro = solucoes.sorted {
        ($0.metricasEconomicas?.lucro ?? 0) > ($1.metricasEconomicas?.lucro ?? 0)
    }
}
```

### 3. Histórico de Análises
```swift
let historicoTerreno = try await AnalysisService.shared.getAllAnalisesTerrenoVersions(projetoId: id)
// Mostrar evolução dos valores ao longo das versões
```

### 4. Verificar Completude do Projeto
```swift
let analises = try await AnalysisService.shared.getTodasAnalises(projetoId: id)
if analises.isComplete {
    // Mostrar relatório completo
} else {
    // Indicar quais análises faltam
}
```

---

## 🔧 Extensões Úteis

Você pode criar extensões para formatar valores:

```swift
extension Double {
    var currencyBR: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: self)) ?? "R$ 0,00"
    }

    var percentage: String {
        return String(format: "%.2f%%", self)
    }
}

// Uso:
print(resumo.melhorLucro?.currencyBR ?? "N/A")
print(resumo.melhorMargem?.percentage ?? "N/A")
```

---

## 📚 Referências

- `ESTRUTURA_DADOS.md`: Documentação completa da estrutura do Firestore
- `Projeto.swift`: Definição de todos os modelos de dados
- `FirestoreService.swift`: Funções de baixo nível do Firestore
- `AnalysisService.swift`: Service de alto nível com funções convenientes
