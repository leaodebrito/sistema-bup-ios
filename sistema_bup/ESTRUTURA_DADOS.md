# Estrutura de Dados - Sistema de Análise de Viabilidade

Este documento descreve a estrutura de dados do sistema de análise de viabilidade de projetos imobiliários armazenada no Firebase Firestore.

---

## 📊 Visão Geral

O sistema utiliza uma arquitetura de **documentos e subcoleções** no Firestore. Cada estudo de viabilidade é representado por um documento principal que contém:
- **Campos diretos**: dados básicos do projeto
- **Subcoleções**: análises detalhadas organizadas em categorias

---

## 🏗️ Estrutura do Documento Principal

### Coleção: `estudos_viabilidade`

Cada documento nesta coleção representa um estudo de viabilidade completo.

### Campos Principais

```json
{
  "_id": "Dtqigvg6F6LjN8j3lh5u",
  "informacao_projeto": { ... },
  "analise_viabilidade": { ... },
  "_subcollections": { ... }
}
```

#### 1. `_id` (string)
Identificador único do documento no Firestore.

#### 2. `informacao_projeto` (objeto)
Informações básicas sobre o projeto imobiliário.

**Campos:**
- `nome_projeto`: Nome/identificador do projeto
- `nome_cliente`: Nome do cliente
- `endereco`: Localização do terreno
- `tipo_projeto`: Tipo de empreendimento (ex: "Apartamento")
- `area_terreno`: Área do terreno em m²
- `latitude` / `longitude`: Coordenadas geográficas
- `data_inicio`: Data de início do estudo
- `descri_projeto`: Descrição do projeto

**Parâmetros Urbanísticos:**
- `zona_urbanistica`: Zoneamento (ex: "ZPR3")
- `ca_min`, `ca_bas`, `ca_max`: Coeficientes de aproveitamento
- `io`: Índice de ocupação
- `ip`: Índice de permeabilidade
- `recuo_frontal`, `recuo_lateral`, `recuo_fundos`: Recuos em metros

**Metadados:**
- `info_criacao`: Objeto com `usuario_criador` e `data_criacao`
- `anotacoes_gerais`: Observações gerais
- `anotacoes_legislacao`: Notas sobre legislação aplicável

#### 3. `analise_viabilidade` (objeto)
Resumo da análise de viabilidade do documento raiz.

**Campos:**
- `solucao_escolhida`: ID da solução arquitetônica escolhida

---

## 📁 O que são Subcoleções?

### Conceito

**Subcoleções** são coleções aninhadas dentro de um documento. No Firestore, elas permitem organizar dados relacionados de forma hierárquica.

```
Firestore
└── estudos_viabilidade (coleção)
    └── Dtqigvg6F6LjN8j3lh5u (documento)
        ├── campos do documento
        └── analise_terreno (subcoleção)
            ├── 1.0 (documento)
            ├── 2.0 (documento)
            └── 3.0 (documento)
```

### Características

- **Hierarquia**: Subcoleções ficam "dentro" de documentos
- **Independência**: Cada documento em uma subcoleção tem seus próprios campos
- **Versionamento**: Comum usar IDs numéricos (1.0, 2.0) para versionar análises
- **Isolamento**: Subcoleções não são carregadas automaticamente com o documento pai

### No JSON Exportado

No arquivo JSON exportado, as subcoleções são representadas pela chave especial `_subcollections`:

```json
{
  "_id": "doc_id",
  "campo1": "valor1",
  "_subcollections": {
    "nome_subcolecao": {
      "doc_id_1": { ... },
      "doc_id_2": { ... }
    }
  }
}
```

---

## 📂 Subcoleções do Sistema

### 1. `analise_espaco_solucoes`

Análise do espaço de soluções arquitetônicas possíveis para o projeto.

**Documentos:** Versões numeradas (1.0, 2.0, 3.0)

**Campos principais:**
```json
{
  "_id": "1.0",
  "versao": "1.0",
  "status": "concluido",
  "data_criacao": "2025-10-13T...",
  "info_criacao": {
    "usuario_criador": "email@example.com",
    "data_criacao": "..."
  },

  "estatisticas_margens": {
    "media": 55.09,
    "mediana": 56.07,
    "minima": 25.61,
    "maxima": 65.72
  },

  "estatisticas_lucros": {
    "medio": 23350917.43,
    "mediano": 23431923.19,
    "minimo": 4312261.30,
    "maximo": 40201424.03
  },

  "metricas_criterios": {
    "todos_criterios": {
      "quantidade": 175,
      "percentual": 0.22
    },
    "criterio_minimo_unidades": { ... },
    "criterio_margem_minima": { ... }
  },

  "metricas_viabilidade": {
    "solucoes_viaveis": 175,
    "solucoes_inviaveis": 616,
    "taxa_viabilidade": 0.22
  },

  "distribuicoes_valores": {
    "lucros": [ ... ],
    "margens": [ ... ],
    "vpls": [ ... ],
    "tirs": [ ... ]
  }
}
```

**Propósito:** Armazena estatísticas sobre todas as possíveis configurações arquitetônicas analisadas, incluindo métricas de viabilidade econômica.

---

### 2. `analise_mercado`

Análise do mercado imobiliário na região do projeto.

**Documentos:** Versões numeradas (1.0, 2.0, ...)

**Campos principais:**
```json
{
  "_id": "1.0",
  "versao": "1.0",
  "status": "concluido",
  "data_criacao": "2025-10-13T...",

  "precificacao_imovel": {
    "faixa_preco_m2": {
      "minimo": 8500.00,
      "medio": 9200.00,
      "maximo": 10000.00
    },
    "valor_referencia_m2": 9200.00
  },

  "dados_imoveis_regiao": {
    "quantidade_total": 45,
    "imoveis_analisados": [ ... ]
  },

  "precos_imoveis_regiao": {
    "preco_medio_m2": 9200.00,
    "distribuicao_precos": [ ... ]
  },

  "descricao_imoveis_regiao": {
    "tipo_predominante": "apartamento",
    "area_media_m2": 85.5,
    "quartos_medio": 2.8
  },

  "conclusoes_estudo": {
    "demanda_alta": true,
    "competitividade": "media",
    "recomendacao": "Projeto viável para a região"
  }
}
```

**Propósito:** Armazena dados de mercado imobiliário coletados na região, incluindo preços de referência e características dos imóveis.

---

### 3. `analise_terreno`

Análise de precificação e características do terreno.

**Documentos:** Versões numeradas (1.0, 2.0, ...)

**Campos principais:**
```json
{
  "_id": "1.0",
  "versao": "1.0",
  "status": "concluido",
  "data_criacao": "2025-10-13T...",

  "precificacao_terreno": {
    "valor_m2_estimado": 1500.00,
    "valor_total_estimado": 750000.00,
    "faixa_valores": {
      "minimo": 700000.00,
      "maximo": 800000.00
    }
  },

  "dados_amostra": {
    "quantidade_terrenos": 12,
    "terrenos_analisados": [ ... ]
  },

  "estatisticas_por_bairro": {
    "Salvador": {
      "valor_medio_m2": 1500.00,
      "quantidade_amostras": 12
    }
  },

  "parecer_estudo": {
    "confiabilidade": "alta",
    "observacoes": "Amostra representativa da região"
  },

  "metadados": {
    "fonte_dados": "mercado_local",
    "data_coleta": "2025-10-13"
  },

  "descricao": "Análise de precificação baseada em terrenos comparáveis"
}
```

**Propósito:** Avalia o valor de mercado do terreno baseado em dados de terrenos similares na região.

---

### 4. `analise_viabilidade`

Análise detalhada de viabilidade econômica do projeto.

**Documentos:** Versões numeradas (1.0, 2.0, 3.0)

**Campos principais:**
```json
{
  "_id": "1.0",
  "versao": "1.0",
  "status": "concluido",
  "data_criacao": "2025-10-13T...",

  "quantidade_solucoes_avaliadas": 791,
  "quantidade_solucoes_viaveis": 175,

  "visao_geral": {
    "melhor_solucao": {
      "id": "17434",
      "lucro": 40201424.03,
      "margem": 65.72,
      "vpl": 35000000.00,
      "tir": 0.28
    },
    "solucao_mediana": {
      "lucro": 23431923.19,
      "margem": 56.07
    }
  },

  "solucoes_viaveis": [
    {
      "id": "17434",
      "configuracao": {
        "num_pavimentos": 8,
        "unidades_por_pavimento": 4,
        "total_unidades": 32,
        "area_util_unidade": 85.0
      },
      "metricas_economicas": {
        "vgv": 61200000.00,
        "custo_total": 21000000.00,
        "lucro": 40201424.03,
        "margem": 65.72,
        "vpl": 35000000.00,
        "tir": 0.28
      },
      "atende_criterios": true
    }
  ],

  "parecer_viabilidade": {
    "viavel": true,
    "nivel_risco": "baixo",
    "recomendacao": "Projeto altamente viável"
  }
}
```

**Propósito:** Consolida a análise de viabilidade, listando as soluções viáveis e recomendações finais.

---

## 🎯 Exemplo Completo (Mock Simplificado)

```json
{
  "_id": "ABC123XYZ",

  "informacao_projeto": {
    "nome_projeto": "Residencial Vista Verde",
    "nome_cliente": "Construtora XYZ Ltda",
    "endereco": "Rua das Flores, 123 - Bairro Jardim",
    "tipo_projeto": "Apartamento",
    "area_terreno": 800.0,
    "latitude": -12.9714,
    "longitude": -38.5014,
    "data_inicio": "2025-01-15",
    "descri_projeto": "Empreendimento residencial de médio padrão",

    "zona_urbanistica": "ZR2",
    "ca_min": 1.0,
    "ca_bas": 2.0,
    "ca_max": 4.0,
    "io": 0.6,
    "ip": 0.4,
    "recuo_frontal": 5.0,
    "recuo_lateral": 2.0,
    "recuo_fundos": 3.0,

    "info_criacao": {
      "usuario_criador": "engenheiro@construtoraxyz.com",
      "data_criacao": "2025-01-15 10:30:00"
    },
    "anotacoes_gerais": "Cliente deseja projeto com foco em sustentabilidade",
    "anotacoes_legislacao": "Atenção para nova lei de recuos aprovada em 2024"
  },

  "analise_viabilidade": {
    "solucao_escolhida": "SOL_8P4U"
  },

  "_subcollections": {

    "analise_terreno": {
      "1.0": {
        "_id": "1.0",
        "versao": "1.0",
        "status": "concluido",
        "data_criacao": "2025-01-15T14:20:00Z",

        "precificacao_terreno": {
          "valor_m2_estimado": 2000.00,
          "valor_total_estimado": 1600000.00,
          "faixa_valores": {
            "minimo": 1500000.00,
            "maximo": 1700000.00
          }
        },

        "dados_amostra": {
          "quantidade_terrenos": 8,
          "terrenos_analisados": [
            {
              "endereco": "Rua Próxima A",
              "area_m2": 750.0,
              "valor_m2": 1950.00
            },
            {
              "endereco": "Rua Próxima B",
              "area_m2": 850.0,
              "valor_m2": 2050.00
            }
          ]
        },

        "estatisticas_por_bairro": {
          "Bairro Jardim": {
            "valor_medio_m2": 2000.00,
            "quantidade_amostras": 8
          }
        },

        "parecer_estudo": {
          "confiabilidade": "alta",
          "observacoes": "Mercado aquecido na região"
        }
      }
    },

    "analise_mercado": {
      "1.0": {
        "_id": "1.0",
        "versao": "1.0",
        "status": "concluido",
        "data_criacao": "2025-01-16T09:00:00Z",

        "precificacao_imovel": {
          "faixa_preco_m2": {
            "minimo": 7000.00,
            "medio": 8500.00,
            "maximo": 10000.00
          },
          "valor_referencia_m2": 8500.00
        },

        "dados_imoveis_regiao": {
          "quantidade_total": 32,
          "imoveis_analisados": [
            {
              "endereco": "Edifício Solar",
              "area_m2": 90.0,
              "quartos": 3,
              "preco_m2": 8200.00
            },
            {
              "endereco": "Edifício Lunar",
              "area_m2": 85.0,
              "quartos": 2,
              "preco_m2": 8800.00
            }
          ]
        },

        "descricao_imoveis_regiao": {
          "tipo_predominante": "apartamento",
          "area_media_m2": 88.0,
          "quartos_medio": 2.5
        },

        "conclusoes_estudo": {
          "demanda_alta": true,
          "competitividade": "moderada",
          "recomendacao": "Mercado favorável para lançamento"
        }
      }
    },

    "analise_espaco_solucoes": {
      "1.0": {
        "_id": "1.0",
        "versao": "1.0",
        "status": "concluido",
        "data_criacao": "2025-01-17T11:30:00Z",

        "estatisticas_margens": {
          "media": 48.5,
          "mediana": 50.2,
          "minima": 20.1,
          "maxima": 62.8
        },

        "estatisticas_lucros": {
          "medio": 18500000.00,
          "mediano": 19200000.00,
          "minimo": 5000000.00,
          "maximo": 32000000.00
        },

        "metricas_criterios": {
          "todos_criterios": {
            "quantidade": 142,
            "percentual": 0.28
          },
          "criterio_minimo_unidades": {
            "quantidade": 380,
            "percentual": 0.75
          },
          "criterio_margem_minima": {
            "quantidade": 210,
            "percentual": 0.42
          }
        },

        "metricas_viabilidade": {
          "solucoes_viaveis": 142,
          "solucoes_inviaveis": 364,
          "taxa_viabilidade": 0.28
        },

        "distribuicoes_valores": {
          "lucros": [5000000, 8000000, 12000000, 18000000, 25000000, 32000000],
          "margens": [20.1, 30.5, 42.8, 50.2, 58.3, 62.8],
          "vpls": [4500000, 7200000, 10800000, 16200000, 22500000, 28800000],
          "tirs": [0.15, 0.18, 0.22, 0.25, 0.28, 0.32]
        }
      }
    },

    "analise_viabilidade": {
      "1.0": {
        "_id": "1.0",
        "versao": "1.0",
        "status": "concluido",
        "data_criacao": "2025-01-18T16:00:00Z",

        "quantidade_solucoes_avaliadas": 506,
        "quantidade_solucoes_viaveis": 142,

        "visao_geral": {
          "melhor_solucao": {
            "id": "SOL_8P4U",
            "lucro": 32000000.00,
            "margem": 62.8,
            "vpl": 28800000.00,
            "tir": 0.32
          },
          "solucao_mediana": {
            "lucro": 19200000.00,
            "margem": 50.2
          }
        },

        "solucoes_viaveis": [
          {
            "id": "SOL_8P4U",
            "configuracao": {
              "num_pavimentos": 8,
              "unidades_por_pavimento": 4,
              "total_unidades": 32,
              "area_util_unidade": 90.0,
              "quartos": 3,
              "suites": 2,
              "vagas_garagem": 2
            },
            "metricas_economicas": {
              "vgv": 51000000.00,
              "custo_total": 19000000.00,
              "lucro": 32000000.00,
              "margem": 62.8,
              "vpl": 28800000.00,
              "tir": 0.32,
              "payback_anos": 3.5
            },
            "atende_criterios": true
          },
          {
            "id": "SOL_6P6U",
            "configuracao": {
              "num_pavimentos": 6,
              "unidades_por_pavimento": 6,
              "total_unidades": 36,
              "area_util_unidade": 75.0,
              "quartos": 2,
              "suites": 1,
              "vagas_garagem": 1
            },
            "metricas_economicas": {
              "vgv": 45900000.00,
              "custo_total": 21000000.00,
              "lucro": 24900000.00,
              "margem": 54.2,
              "vpl": 22000000.00,
              "tir": 0.28,
              "payback_anos": 4.0
            },
            "atende_criterios": true
          }
        ],

        "parecer_viabilidade": {
          "viavel": true,
          "nivel_risco": "baixo",
          "recomendacao": "Projeto altamente viável. Sugestão de seguir com solução SOL_8P4U."
        }
      },

      "2.0": {
        "_id": "2.0",
        "versao": "2.0",
        "status": "em_analise",
        "data_criacao": "2025-01-20T10:00:00Z",

        "quantidade_solucoes_avaliadas": 506,
        "quantidade_solucoes_viaveis": 158,

        "visao_geral": {
          "melhor_solucao": {
            "id": "SOL_10P3U",
            "lucro": 35000000.00,
            "margem": 65.2,
            "vpl": 31500000.00,
            "tir": 0.34
          }
        },

        "parecer_viabilidade": {
          "viavel": true,
          "nivel_risco": "baixo",
          "recomendacao": "Análise revisada com novos parâmetros de custo. Ainda mais viável."
        }
      }
    }

  }
}
```

---

## 🔄 Fluxo de Versionamento

As subcoleções utilizam documentos numerados (1.0, 2.0, 3.0) para representar diferentes versões de análises:

1. **Versão 1.0**: Análise inicial
2. **Versão 2.0**: Análise revisada com novos dados ou parâmetros
3. **Versão 3.0**: Análise final ou ajustes adicionais

Isso permite:
- **Histórico completo**: Todas as versões são mantidas
- **Comparação**: Possível comparar diferentes cenários
- **Rastreabilidade**: Auditar mudanças nas análises ao longo do tempo

---

## 📝 Campos Especiais

### `_id`
- Identificador único do documento
- Adicionado automaticamente pelo Firestore ou pelo script de exportação

### `_subcollections`
- Campo especial usado apenas no JSON exportado
- Não existe no Firestore real
- Agrupa todas as subcoleções do documento

### `status`
- Indica o estado da análise
- Valores comuns: `"concluido"`, `"em_analise"`, `"pendente"`

### `info_criacao` / `data_criacao`
- Metadados de auditoria
- Registra quem e quando criou o registro

---

## 🛠️ Como Usar Esta Estrutura

### Para Desenvolvedores

1. **Consultar dados do projeto**:
   ```javascript
   const docRef = db.collection('estudos_viabilidade').doc('ABC123XYZ');
   const doc = await docRef.get();
   const dados = doc.data();
   ```

2. **Acessar subcoleção**:
   ```javascript
   const analisesTerrenoRef = docRef.collection('analise_terreno');
   const snapshot = await analisesTerrenoRef.get();
   ```

3. **Versão específica**:
   ```javascript
   const versao1 = await docRef.collection('analise_viabilidade').doc('1.0').get();
   ```

### Para Exportação

Use o script `baixar_dados.py` para exportar toda a estrutura em JSON:

```bash
python baixar_dados.py
```

O script irá:
- Baixar o documento principal
- Buscar todas as subcoleções recursivamente
- Converter tipos especiais do Firestore
- Salvar tudo em um arquivo JSON estruturado

---

## 📚 Glossário

- **CA (Coeficiente de Aproveitamento)**: Relação entre área construída e área do terreno
- **IO (Índice de Ocupação)**: Percentual do terreno que pode ser ocupado
- **IP (Índice de Permeabilidade)**: Percentual do terreno que deve ser permeável
- **VGV (Valor Geral de Vendas)**: Receita total prevista com as vendas
- **VPL (Valor Presente Líquido)**: Valor do investimento trazido a valor presente
- **TIR (Taxa Interna de Retorno)**: Rentabilidade percentual do investimento
- **Margem**: Percentual de lucro sobre o VGV

---

## 🎓 Conclusão

A estrutura de dados do sistema utiliza o modelo hierárquico do Firestore de forma eficiente:

- **Documento raiz** contém informações básicas e resumos
- **Subcoleções** organizam análises detalhadas por categoria
- **Versionamento** permite evolução e histórico das análises
- **Hierarquia clara** facilita manutenção e escalabilidade

Esta arquitetura permite que cada análise seja atualizada independentemente, mantendo um histórico completo de todas as versões e facilitando a comparação entre diferentes cenários de viabilidade.
