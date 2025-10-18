# CLAUDE_IOS.md - Instruções de Desenvolvimento iOS
> BuidUp Mobile - Sistema de Análise de Mercado Imobiliário - iOS

## 🎯 Sobre o Projeto Mobile

**BuidUp Mobile** é a versão nativa iOS do sistema de análise de mercado imobiliário e estudos de viabilidade de projetos. O aplicativo mantém a mesma lógica de negócio do sistema web, adaptada para a experiência mobile com interface SwiftUI.

---

## ✅ Status Atual da Implementação

### Implementado:
- ✅ **Autenticação Firebase** (Login com Email/Senha)
  - `AuthController` (MVC Controller)
  - `AuthService` (Firebase Auth Service)
  - `LoginView` (Tela de login)
- ✅ **Navegação Principal**
  - `ContentView` com TabView (3 abas: Início, Projetos, Assistente)
  - `Inicio.swift` - Tela inicial com cards de funcionalidades
  - `Usuario.swift` - Tela de perfil do usuário com informações do Firebase Auth
- ✅ **Fluxo de Autenticação**
  - Redirect automático: Login → ContentView
  - Logout volta para LoginView
  - Persistência de sessão Firebase

### Pendente:
- ⏳ Tela de Projetos (funcionalidade completa)
- ⏳ Tela de Assistente IA
- ⏳ Integração com Firestore (modelos e serviços)
- ⏳ Análise de Mercado
- ⏳ Análise de Terreno
- ⏳ Análise de Viabilidade

---

## 🏗️ Arquitetura Implementada

### Stack Tecnológica iOS

**Framework & Linguagem:**
- **SwiftUI**: Interface declarativa (iOS 15+)
- **Swift 5.9+**: Linguagem nativa
- **Combine**: Programação reativa

**Backend & Persistência:**
- **Firebase iOS SDK**: Integração com Firestore (mesma base de dados do web)
- **Firebase Auth**: Autenticação (compatível com sistema web)
- **Keychain**: Armazenamento seguro de credenciais

**Visualização de Dados:**
- **Charts (SwiftUI)**: Gráficos nativos (iOS 16+)
- **Swift Charts**: Alternativa para visualizações complexas
- **MapKit**: Mapas interativos (substitui Folium)

**Networking:**
- **URLSession**: Requisições HTTP para APIs externas
- **Codable**: Serialização JSON

**Arquitetura:**
- **MVC (Model-View-Controller)**: Separação de responsabilidades
- **Service Pattern**: Abstração de dados (Firebase + APIs)
- **Dependency Injection**: Gerenciamento via @EnvironmentObject

---

## 📂 Estrutura Atual do Projeto

```
sistema_bup/
├── sistema_bupApp.swift               # Entry point com AppDelegate
├── ContentView.swift                  # TabView principal (Inicio, Projetos, Assistente)
│
├── Core/                              # Funcionalidades compartilhadas
│   ├── Authentication/
│   │   ├── Controllers/
│   │   │   └── AuthController.swift   # Controller de autenticação (MVC)
│   │   ├── Services/
│   │   │   └── AuthService.swift      # Serviço Firebase Auth
│   │   └── Views/
│   │       └── LoginView.swift        # Tela de login
│   │
│   ├── Models/                        # Modelos de dados
│   │   └── (vazio - modelos serão adicionados)
│   │
│   ├── Services/                      # Serviços compartilhados
│   │   └── (vazio - serviços serão adicionados)
│   │
│   └── Extensions/                    # Extensões úteis
│       └── (vazio - extensões serão adicionadas)
│
└── Views/                             # Views principais (estrutura atual)
    ├── Inicio.swift                   # Tela inicial com cards de funcionalidades
    ├── Projetos.swift                 # Tela de projetos (placeholder)
    ├── Usuario.swift                  # Tela de perfil do usuário
    └── Assistente.swift               # Tela do assistente IA (placeholder)
│   │
│   ├── LandAnalysis/                  # Análise de Terreno
│   │   ├── Views/
│   │   │   ├── LandAnalysisView.swift
│   │   │   ├── LandPricingView.swift
│   │   │   └── LandMapView.swift
│   │   ├── ViewModels/
│   │   │   └── LandAnalysisViewModel.swift
│   │   └── Components/
│   │       ├── LandStatsCardView.swift
│   │       └── OutlierChartView.swift
│   │
│   ├── Viability/                     # Análise de Viabilidade
│   │   ├── Views/
│   │   │   ├── ViabilityView.swift
│   │   │   ├── ConfigurationView.swift          # Config colunas
│   │   │   ├── DatasetAnalysisView.swift        # Dataset completo
│   │   │   ├── ViableSolutionsView.swift        # Soluções viáveis
│   │   │   └── SolutionDetailView.swift         # Análise individual
│   │   ├── ViewModels/
│   │   │   ├── ViabilityViewModel.swift
│   │   │   └── ConfigurationViewModel.swift
│   │   └── Components/
│   │       ├── ViabilityMetricsView.swift
│   │       ├── CriteriaAnalysisView.swift
│   │       ├── ProfitChartView.swift
│   │       └── CategoryTabsView.swift           # 5 abas
│   │
│   └── AIAssistant/                   # Assistente IA
│       ├── Views/
│       │   ├── ChatView.swift
│       │   └── NormsBrowserView.swift
│       ├── ViewModels/
│       │   └── AIViewModel.swift
│       └── Components/
│           ├── MessageBubbleView.swift
│           └── ChatInputView.swift
│
├── Shared/                            # Componentes reutilizáveis
│   ├── Components/
│   │   ├── LoadingView.swift
│   │   ├── ErrorView.swift
│   │   ├── EmptyStateView.swift
│   │   ├── CustomButton.swift
│   │   └── FormField.swift
│   │
│   ├── Charts/
│   │   ├── PieChartView.swift
│   │   ├── BarChartView.swift
│   │   ├── LineChartView.swift
│   │   └── HistogramView.swift
│   │
│   └── Utils/
│       ├── Constants.swift
│       ├── Logger.swift
│       └── Formatters.swift
│
├── Resources/
│   ├── Assets.xcassets
│   ├── GoogleService-Info.plist      # Firebase config
│   └── Localizable.strings
│
└── Config/
    ├── Development.xcconfig
    ├── Production.xcconfig
    └── Info.plist
```

---

## 🔧 Configuração Inicial do Projeto

### 1. Criar Projeto Xcode

```bash
# Via Xcode
File > New > Project > iOS > App
- Product Name: BuidUpMobile
- Interface: SwiftUI
- Language: Swift
- Minimum Deployment: iOS 15.0
```

### 2. Instalar Dependências (Swift Package Manager)

**Firebase iOS SDK:**
```
https://github.com/firebase/firebase-ios-sdk
```

Pacotes necessários:
- FirebaseAuth
- FirebaseFirestore
- FirebaseStorage (opcional, para uploads futuros)

**Opcional (Networking):**
```
https://github.com/Alamofire/Alamofire
```

### 3. Configurar Firebase

**Passo 1:** Adicionar iOS app no Firebase Console
- Bundle ID: `com.buildup.mobile`
- Download `GoogleService-Info.plist`

**Passo 2:** Configurar AppDelegate (IMPLEMENTADO)

```swift
// sistema_bupApp.swift
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct YourApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject private var authController = AuthController()

  var body: some Scene {
    WindowGroup {
      if authController.isAuthenticated {
        ContentView()
          .environmentObject(authController)
      } else {
        LoginView()
          .environmentObject(authController)
      }
    }
  }
}
```

### 4. Configurar Build Configurations

**Development.xcconfig:**
```
AMBIENTE = teste
URL_RENDER = https://sua-api-teste.com
COLECAO_FIRESTORE = estudos_viabilidade
```

**Production.xcconfig:**
```
AMBIENTE = producao
URL_RENDER = https://sua-api-producao.com
COLECAO_FIRESTORE = estudos_viabilidade
```

---

## 🗄️ Modelos de Dados (Swift)

### Projeto Base

```swift
// Core/Firebase/Models/Projeto.swift
import Foundation
import FirebaseFirestore

struct Projeto: Identifiable, Codable {
    @DocumentID var id: String?
    let nomeProjeto: String
    let tipoProjeto: String
    let descriProjeto: String
    let nomeCliente: String
    let dataInicio: String
    let endereco: String
    let infoCriacao: InfoCriacao

    // Referências para subcoleções (IDs)
    var analiseMercadoId: String?
    var analiseViabilidadeId: String?
    var analiseEspacoSolucoesId: String?
    var analiseTerreno: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nomeProjeto = "nome_projeto"
        case tipoProjeto = "tipo_projeto"
        case descriProjeto = "descri_projeto"
        case nomeCliente = "nome_cliente"
        case dataInicio = "data_inicio"
        case endereco
        case infoCriacao = "info_criacao"
        case analiseMercadoId = "analise_mercado_id"
        case analiseViabilidadeId = "analise_viabilidade_id"
        case analiseEspacoSolucoesId = "analise_espaco_solucoes_id"
        case analiseTerreno = "analise_terreno"
    }
}

struct InfoCriacao: Codable {
    let dataCriacao: Date
    let usuarioCriador: String

    enum CodingKeys: String, CodingKey {
        case dataCriacao = "data_criacao"
        case usuarioCriador = "usuario_criador"
    }
}
```

### Análise de Viabilidade

```swift
// Core/Firebase/Models/AnaliseViabilidade.swift
struct AnaliseViabilidade: Identifiable, Codable {
    @DocumentID var id: String?
    let dataCriacao: String
    let parecerViabilidade: ParecerViabilidade
    let parecerInfo: ParecerInfo
    let solucoesViaveis: [SolucaoViavel]

    enum CodingKeys: String, CodingKey {
        case id
        case dataCriacao = "data_criacao"
        case parecerViabilidade = "parecer_viabilidade"
        case parecerInfo = "parecer_info"
        case solucoesViaveis = "solucoes_viaveis"
    }
}

struct ParecerViabilidade: Codable {
    let parecer: String
}

struct ParecerInfo: Codable {
    let dataAtualizacao: String
    let usuario: String
    let solucaoEscolhida: String
    let quantidadeSolucoesAvaliadas: Int
    let quantidadeSolucoesViaveis: Int

    enum CodingKeys: String, CodingKey {
        case dataAtualizacao = "data_atualizacao"
        case usuario
        case solucaoEscolhida = "solucao_escolhida"
        case quantidadeSolucoesAvaliadas = "quantidade_solucoes_avaliadas"
        case quantidadeSolucoesViaveis = "quantidade_solucoes_viaveis"
    }
}

struct SolucaoViavel: Identifiable, Codable {
    let id: Int
    let receita: Double
    let custoTotalEmpreendimento: Double
    let lucroIncorporacao: Double
    let areaTerreno: Double?
    let tipologia: String?
    let areaVendaTotal: Double?
    let to: Double?
    let ca: Double?
    let numPavResidencial: Int?
    let quantUnidadesResidenciais: Int?
    let precoVendaResidencial: Double?

    // Computed properties
    var margemLucro: Double {
        guard receita > 0 else { return 0 }
        return (lucroIncorporacao / receita) * 100
    }

    var viavel: Bool {
        margemLucro >= 16
    }

    enum CodingKeys: String, CodingKey {
        case id = "index"
        case receita
        case custoTotalEmpreendimento = "custo_total_empreendimento"
        case lucroIncorporacao = "lucro_incorporacao"
        case areaTerreno = "area_terreno"
        case tipologia
        case areaVendaTotal = "area_venda_total"
        case to = "TO"
        case ca = "CA"
        case numPavResidencial = "num_pav_residencial"
        case quantUnidadesResidenciais = "quant_unidades_residenciais"
        case precoVendaResidencial = "preco_venda_residencial"
    }
}
```

### Análise de Mercado

```swift
// Core/Firebase/Models/AnaliseMercado.swift
struct AnaliseMercado: Identifiable, Codable {
    @DocumentID var id: String?
    let dataCriacao: Date
    let precosImoveisRegiao: PrecosImoveisRegiao
    let descricaoImoveisRegiao: DescricaoImoveisRegiao
    let precificacaoImovel: PrecificacaoImovel
    let conclusoesEstudo: ConclsusoesEstudo
    let infoCriacao: InfoCriacao

    enum CodingKeys: String, CodingKey {
        case id
        case dataCriacao = "data_criacao"
        case precosImoveisRegiao = "precos_imoveis_regiao"
        case descricaoImoveisRegiao = "descricao_imoveis_regiao"
        case precificacaoImovel = "precificacao_imovel"
        case conclusoesEstudo = "conclusoes_estudo"
        case infoCriacao = "info_criacao"
    }
}

struct PrecosImoveisRegiao: Codable {
    let bairrosAnalisados: [String]
    let infoAreaMin: Double
    let infoAreaMax: Double
    let valorMediaBairro: Double
    let valorMedianaBairro: Double
    let valorMinimoBairro: Double
    let valorMaximoBairro: Double
    let valorMediaCidade: Double
    let valorMedianaCidade: Double

    enum CodingKeys: String, CodingKey {
        case bairrosAnalisados = "bairros_analisados"
        case infoAreaMin = "info_area_min"
        case infoAreaMax = "info_area_max"
        case valorMediaBairro = "valor_media_bairro"
        case valorMedianaBairro = "valor_mediana_bairro"
        case valorMinimoBairro = "valor_minimo_bairro"
        case valorMaximoBairro = "valor_maximo_bairro"
        case valorMediaCidade = "valor_media_cidade"
        case valorMedianaCidade = "valor_mediana_cidade"
    }
}

struct DescricaoImoveisRegiao: Codable {
    let dicioArea: EstatisticasDistribuicao
    let dicioQuartos: EstatisticasDistribuicao
    let dicioVagas: EstatisticasDistribuicao

    enum CodingKeys: String, CodingKey {
        case dicioArea = "dicio_area"
        case dicioQuartos = "dicio_quartos"
        case dicioVagas = "dicio_vagas"
    }
}

struct EstatisticasDistribuicao: Codable {
    let media: Double
    let mediana: Double
    let std: Double
    let min: Double
    let max: Double
    let q25: Double
    let q75: Double
}

struct PrecificacaoImovel: Codable {
    let cidade: String
    let latitude: Double
    let longitude: Double
    let area: Double
    let quartos: Int
    let banheiros: Int
    let garagem: Int
    let idadeImovel: Int
    let qualidadeImovel: Int
    let tipo: String
    let valorUnitarioEstimado: Double
    let valorVendaEstimado: Double

    enum CodingKeys: String, CodingKey {
        case cidade
        case latitude
        case longitude
        case area
        case quartos
        case banheiros
        case garagem
        case idadeImovel = "idade_imovel"
        case qualidadeImovel = "qualidade_imovel"
        case tipo
        case valorUnitarioEstimado = "valor_unitario_estimado"
        case valorVendaEstimado = "valor_venda_estimado"
    }
}

struct ConclsusoesEstudo: Codable {
    let parecerEstudo: String
    let precoVendaAdotado: Double
    let precoUnitarioVendaAdotado: Double

    enum CodingKeys: String, CodingKey {
        case parecerEstudo = "parecer_estudo"
        case precoVendaAdotado = "preco_venda_adotado"
        case precoUnitarioVendaAdotado = "preco_unitario_venda_adotado"
    }
}
```

---

## 🔐 Autenticação (Firebase Auth)

### AuthService

```swift
// Core/Authentication/Services/AuthService.swift
import FirebaseAuth
import Combine

enum AuthError: LocalizedError {
    case invalidCredentials
    case userNotFound
    case weakPassword
    case emailAlreadyInUse
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Email ou senha inválidos"
        case .userNotFound:
            return "Usuário não encontrado"
        case .weakPassword:
            return "Senha muito fraca. Use no mínimo 6 caracteres"
        case .emailAlreadyInUse:
            return "Este email já está em uso"
        case .unknown(let message):
            return message
        }
    }
}

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()

    var currentUser: User? {
        auth.currentUser
    }

    var isAuthenticated: Bool {
        currentUser != nil
    }

    // Login
    func signIn(email: String, password: String) async throws {
        do {
            try await auth.signIn(withEmail: email, password: password)
        } catch let error as NSError {
            throw mapAuthError(error)
        }
    }

    // Registro
    func signUp(email: String, password: String) async throws {
        do {
            try await auth.createUser(withEmail: email, password: password)
        } catch let error as NSError {
            throw mapAuthError(error)
        }
    }

    // Logout
    func signOut() throws {
        try auth.signOut()
    }

    // Mapear erros Firebase para erros customizados
    private func mapAuthError(_ error: NSError) -> AuthError {
        guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
            return .unknown(error.localizedDescription)
        }

        switch errorCode {
        case .invalidCredential, .wrongPassword:
            return .invalidCredentials
        case .userNotFound:
            return .userNotFound
        case .weakPassword:
            return .weakPassword
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
```

### AuthViewModel

```swift
// Core/Authentication/ViewModels/AuthViewModel.swift
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observar mudanças no estado de autenticação
        user = authService.currentUser
        isAuthenticated = authService.isAuthenticated
    }

    // Login
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await authService.signIn(email: email, password: password)
            user = authService.currentUser
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // Registro
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await authService.signUp(email: email, password: password)
            user = authService.currentUser
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // Logout
    func signOut() {
        do {
            try authService.signOut()
            user = nil
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

### LoginView

```swift
// Core/Authentication/Views/LoginView.swift
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                Text("BuidUp Mobile")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Form
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SecureField("Senha", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.password)
                }
                .padding(.horizontal)

                // Error message
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Login button
                Button {
                    Task {
                        await authViewModel.signIn(email: email, password: password)
                    }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Entrar")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(authViewModel.isLoading)

                // Register link
                NavigationLink {
                    RegisterView()
                } label: {
                    Text("Não tem conta? Cadastre-se")
                        .font(.footnote)
                }

                Spacer()
            }
            .padding()
        }
    }
}
```

---

## 🔥 Serviço Firebase (Firestore)

### FirestoreService

```swift
// Core/Firebase/FirestoreService.swift
import FirebaseFirestore
import Combine

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    private let collectionName = "estudos_viabilidade"

    // MARK: - Projetos

    // Listar todos os projetos
    func fetchProjetos() async throws -> [Projeto] {
        let snapshot = try await db.collection(collectionName).getDocuments()
        return try snapshot.documents.compactMap { document in
            try document.data(as: Projeto.self)
        }
    }

    // Buscar projeto por ID
    func fetchProjeto(id: String) async throws -> Projeto {
        let document = try await db.collection(collectionName).document(id).getDocument()
        guard let projeto = try? document.data(as: Projeto.self) else {
            throw FirestoreError.projetoNaoEncontrado
        }
        return projeto
    }

    // Criar novo projeto
    func createProjeto(_ projeto: Projeto) async throws -> String {
        let ref = try db.collection(collectionName).addDocument(from: projeto)
        return ref.documentID
    }

    // Atualizar projeto
    func updateProjeto(_ projeto: Projeto) async throws {
        guard let id = projeto.id else {
            throw FirestoreError.idInvalido
        }
        try db.collection(collectionName).document(id).setData(from: projeto, merge: true)
    }

    // Deletar projeto
    func deleteProjeto(id: String) async throws {
        try await db.collection(collectionName).document(id).delete()
    }

    // MARK: - Análise de Viabilidade (Subcoleção)

    // Buscar análise de viabilidade (versão específica)
    func fetchAnaliseViabilidade(projetoId: String, versao: String = "1.0") async throws -> AnaliseViabilidade {
        let document = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_viabilidade")
            .document(versao)
            .getDocument()

        guard let analise = try? document.data(as: AnaliseViabilidade.self) else {
            throw FirestoreError.analiseNaoEncontrada
        }
        return analise
    }

    // Listar versões de análise de viabilidade
    func fetchVersoesAnaliseViabilidade(projetoId: String) async throws -> [String] {
        let snapshot = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_viabilidade")
            .getDocuments()

        return snapshot.documents.map { $0.documentID }.sorted()
    }

    // Salvar análise de viabilidade (nova versão)
    func saveAnaliseViabilidade(projetoId: String, analise: AnaliseViabilidade, versao: String) async throws {
        try db.collection(collectionName)
            .document(projetoId)
            .collection("analise_viabilidade")
            .document(versao)
            .setData(from: analise)
    }

    // Atualizar parecer de viabilidade
    func updateParecerViabilidade(projetoId: String, versao: String, parecer: String, solucaoEscolhida: String) async throws {
        let data: [String: Any] = [
            "parecer_viabilidade.parecer": parecer,
            "parecer_info.data_atualizacao": DateFormatter.firebaseFormatter.string(from: Date()),
            "parecer_info.solucao_escolhida": solucaoEscolhida
        ]

        try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_viabilidade")
            .document(versao)
            .updateData(data)
    }

    // MARK: - Análise de Mercado (Subcoleção)

    func fetchAnaliseMercado(projetoId: String, versao: String = "1.0") async throws -> AnaliseMercado {
        let document = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_mercado")
            .document(versao)
            .getDocument()

        guard let analise = try? document.data(as: AnaliseMercado.self) else {
            throw FirestoreError.analiseNaoEncontrada
        }
        return analise
    }

    // MARK: - Análise de Espaço de Soluções (Subcoleção)

    func fetchAnaliseEspacoSolucoes(projetoId: String, versao: String = "1.0") async throws -> AnaliseEspacoSolucoes {
        let document = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_espaco_solucoes")
            .document(versao)
            .getDocument()

        guard let analise = try? document.data(as: AnaliseEspacoSolucoes.self) else {
            throw FirestoreError.analiseNaoEncontrada
        }
        return analise
    }
}

// Erros customizados
enum FirestoreError: LocalizedError {
    case projetoNaoEncontrado
    case analiseNaoEncontrada
    case idInvalido
    case erroDesconhecido(String)

    var errorDescription: String? {
        switch self {
        case .projetoNaoEncontrado:
            return "Projeto não encontrado"
        case .analiseNaoEncontrada:
            return "Análise não encontrada"
        case .idInvalido:
            return "ID inválido"
        case .erroDesconhecido(let message):
            return message
        }
    }
}

// Extension para DateFormatter
extension DateFormatter {
    static let firebaseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()
}
```

---

## 📊 Feature: Análise de Viabilidade

### ViabilityViewModel

```swift
// Features/Viability/ViewModels/ViabilityViewModel.swift
import SwiftUI
import Combine

@MainActor
class ViabilityViewModel: ObservableObject {
    @Published var analiseViabilidade: AnaliseViabilidade?
    @Published var analiseEspacoSolucoes: AnaliseEspacoSolucoes?
    @Published var solucoesViaveis: [SolucaoViavel] = []
    @Published var solucaoSelecionada: SolucaoViavel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Filtros
    @Published var filtroTipologia: String = "Todos"
    @Published var filtroMargemMinima: Double = 16.0

    private let firestoreService = FirestoreService.shared
    private var projetoId: String

    init(projetoId: String) {
        self.projetoId = projetoId
    }

    // Carregar dados
    func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            // Carregar análise de viabilidade
            analiseViabilidade = try await firestoreService.fetchAnaliseViabilidade(projetoId: projetoId)
            solucoesViaveis = analiseViabilidade?.solucoesViaveis ?? []

            // Carregar análise de espaço de soluções
            analiseEspacoSolucoes = try await firestoreService.fetchAnaliseEspacoSolucoes(projetoId: projetoId)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // Soluções filtradas
    var solucoesFiltradas: [SolucaoViavel] {
        solucoesViaveis.filter { solucao in
            // Filtro de tipologia
            let matchTipologia = filtroTipologia == "Todos" || solucao.tipologia == filtroTipologia

            // Filtro de margem mínima
            let matchMargem = solucao.margemLucro >= filtroMargemMinima

            return matchTipologia && matchMargem
        }
        .sorted { $0.lucroIncorporacao > $1.lucroIncorporacao }
    }

    // Tipologias únicas
    var tipologiasDisponiveis: [String] {
        let tipologias = Set(solucoesViaveis.compactMap { $0.tipologia })
        return ["Todos"] + tipologias.sorted()
    }

    // Estatísticas das soluções filtradas
    var estatisticas: EstatisticasViabilidade {
        let lucros = solucoesFiltradas.map { $0.lucroIncorporacao }
        let margens = solucoesFiltradas.map { $0.margemLucro }

        return EstatisticasViabilidade(
            totalSolucoes: solucoesFiltradas.count,
            lucroMedio: lucros.reduce(0, +) / Double(lucros.count),
            lucroMaximo: lucros.max() ?? 0,
            lucroMinimo: lucros.min() ?? 0,
            margemMedia: margens.reduce(0, +) / Double(margens.count),
            margemMaxima: margens.max() ?? 0,
            margemMinima: margens.min() ?? 0
        )
    }

    // Atualizar parecer
    func updateParecer(parecer: String, solucaoEscolhida: String) async {
        isLoading = true

        do {
            try await firestoreService.updateParecerViabilidade(
                projetoId: projetoId,
                versao: "1.0",
                parecer: parecer,
                solucaoEscolhida: solucaoEscolhida
            )
            await loadData() // Recarregar dados
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

struct EstatisticasViabilidade {
    let totalSolucoes: Int
    let lucroMedio: Double
    let lucroMaximo: Double
    let lucroMinimo: Double
    let margemMedia: Double
    let margemMaxima: Double
    let margemMinima: Double
}
```

### ViabilityView

```swift
// Features/Viability/Views/ViabilityView.swift
import SwiftUI

struct ViabilityView: View {
    @StateObject private var viewModel: ViabilityViewModel
    @State private var selectedTab = 0

    init(projetoId: String) {
        _viewModel = StateObject(wrappedValue: ViabilityViewModel(projetoId: projetoId))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Carregando análise...")
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task {
                        await viewModel.loadData()
                    }
                }
            } else {
                TabView(selection: $selectedTab) {
                    // Aba 1: Métricas Gerais
                    MetricsOverviewView(
                        analiseEspacoSolucoes: viewModel.analiseEspacoSolucoes,
                        estatisticas: viewModel.estatisticas
                    )
                    .tabItem {
                        Label("Métricas", systemImage: "chart.bar")
                    }
                    .tag(0)

                    // Aba 2: Soluções Viáveis
                    ViableSolutionsView(
                        solucoes: viewModel.solucoesFiltradas,
                        filtroTipologia: $viewModel.filtroTipologia,
                        filtroMargemMinima: $viewModel.filtroMargemMinima,
                        tipologias: viewModel.tipologiasDisponiveis,
                        onSelectSolution: { solucao in
                            viewModel.solucaoSelecionada = solucao
                        }
                    )
                    .tabItem {
                        Label("Soluções", systemImage: "list.bullet")
                    }
                    .tag(1)

                    // Aba 3: Parecer
                    ParecerView(
                        parecer: viewModel.analiseViabilidade?.parecerViabilidade.parecer ?? "",
                        parecerInfo: viewModel.analiseViabilidade?.parecerInfo,
                        onSave: { novoParecer, solucaoEscolhida in
                            Task {
                                await viewModel.updateParecer(parecer: novoParecer, solucaoEscolhida: solucaoEscolhida)
                            }
                        }
                    )
                    .tabItem {
                        Label("Parecer", systemImage: "doc.text")
                    }
                    .tag(2)
                }
            }
        }
        .navigationTitle("Análise de Viabilidade")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadData()
        }
        .sheet(item: $viewModel.solucaoSelecionada) { solucao in
            SolutionDetailView(solucao: solucao)
        }
    }
}
```

### ViableSolutionsView

```swift
// Features/Viability/Views/ViableSolutionsView.swift
import SwiftUI

struct ViableSolutionsView: View {
    let solucoes: [SolucaoViavel]
    @Binding var filtroTipologia: String
    @Binding var filtroMargemMinima: Double
    let tipologias: [String]
    let onSelectSolution: (SolucaoViavel) -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Filtros
            VStack(spacing: 12) {
                // Filtro de Tipologia
                HStack {
                    Text("Tipologia:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Picker("Tipologia", selection: $filtroTipologia) {
                        ForEach(tipologias, id: \.self) { tipologia in
                            Text(tipologia).tag(tipologia)
                        }
                    }
                    .pickerStyle(.menu)
                }

                // Filtro de Margem Mínima
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Margem mínima:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()

                        Text("\(filtroMargemMinima, specifier: "%.1f")%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }

                    Slider(value: $filtroMargemMinima, in: 0...50, step: 1)
                }
            }
            .padding()
            .background(Color(.systemGray6))

            // Lista de soluções
            if solucoes.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "Nenhuma solução encontrada",
                    message: "Ajuste os filtros para ver mais resultados"
                )
            } else {
                List {
                    ForEach(solucoes) { solucao in
                        SolutionRowView(solucao: solucao)
                            .onTapGesture {
                                onSelectSolution(solucao)
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct SolutionRowView: View {
    let solucao: SolucaoViavel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Solução #\(solucao.id)")
                    .font(.headline)

                Spacer()

                // Badge de margem
                Text("\(solucao.margemLucro, specifier: "%.1f")%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(margemColor(solucao.margemLucro))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Tipologia
            if let tipologia = solucao.tipologia {
                Text(tipologia)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Divider()

            // Métricas principais
            HStack(spacing: 20) {
                MetricView(
                    title: "Receita",
                    value: solucao.receita.formatarComoMoeda()
                )

                MetricView(
                    title: "Custo",
                    value: solucao.custoTotalEmpreendimento.formatarComoMoeda()
                )

                MetricView(
                    title: "Lucro",
                    value: solucao.lucroIncorporacao.formatarComoMoeda()
                )
            }
        }
        .padding(.vertical, 8)
    }

    private func margemColor(_ margem: Double) -> Color {
        switch margem {
        case 30...: return .green
        case 20..<30: return .blue
        case 16..<20: return .orange
        default: return .red
        }
    }
}

struct MetricView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)

            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}
```

---

## 🎨 Extensões de Formatação

### Double+Extensions

```swift
// Core/Extensions/Double+Extensions.swift
import Foundation

extension Double {
    // Formatar como moeda (R$)
    func formatarComoMoeda() -> String {
        if self >= 1_000_000 {
            return String(format: "R$ %.2fM", self / 1_000_000)
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "R$"
            formatter.locale = Locale(identifier: "pt_BR")
            return formatter.string(from: NSNumber(value: self)) ?? "R$ 0,00"
        }
    }

    // Formatar como área (m²)
    func formatarComoArea() -> String {
        return String(format: "%.2f m²", self)
    }

    // Formatar como percentual
    func formatarComoPercentual(casasDecimais: Int = 2) -> String {
        return String(format: "%.\(casasDecimais)f%%", self)
    }

    // Formatar como índice urbanístico (4 decimais)
    func formatarComoIndice() -> String {
        return String(format: "%.4f", self)
    }

    // Formatar como dimensão linear (m)
    func formatarComoDimensao() -> String {
        return String(format: "%.2f m", self)
    }
}
```

---

## 📈 Componentes de Gráficos

### PieChartView (usando Swift Charts)

```swift
// Shared/Charts/PieChartView.swift
import SwiftUI
import Charts

struct PieChartData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

struct PieChartView: View {
    let data: [PieChartData]
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            Chart(data) { item in
                SectorMark(
                    angle: .value("Value", item.value),
                    innerRadius: .ratio(0.5),
                    angularInset: 1.5
                )
                .foregroundStyle(item.color)
                .cornerRadius(5)
            }
            .frame(height: 200)

            // Legenda
            VStack(alignment: .leading, spacing: 8) {
                ForEach(data) { item in
                    HStack {
                        Circle()
                            .fill(item.color)
                            .frame(width: 12, height: 12)

                        Text(item.label)
                            .font(.caption)

                        Spacer()

                        Text("\(item.value, specifier: "%.1f")%")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}
```

---

## 🗺️ Componentes de Mapa

### MapView (usando MapKit)

```swift
// Features/MarketAnalysis/Views/PriceMapView.swift
import SwiftUI
import MapKit

struct Imovel: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let preco: Double
    let precoUnitario: Double
    let endereco: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct PriceMapView: View {
    let imoveis: [Imovel]
    @State private var region: MKCoordinateRegion

    init(imoveis: [Imovel]) {
        self.imoveis = imoveis

        // Calcular centro do mapa
        let avgLat = imoveis.map { $0.latitude }.reduce(0, +) / Double(imoveis.count)
        let avgLon = imoveis.map { $0.longitude }.reduce(0, +) / Double(imoveis.count)

        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: imoveis) { imovel in
            MapAnnotation(coordinate: imovel.coordinate) {
                PriceMarkerView(precoUnitario: imovel.precoUnitario)
                    .onTapGesture {
                        // Mostrar detalhes do imóvel
                    }
            }
        }
        .frame(height: 400)
        .cornerRadius(12)
    }
}

struct PriceMarkerView: View {
    let precoUnitario: Double

    var body: some View {
        VStack(spacing: 0) {
            Text(precoUnitario.formatarComoMoeda())
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(markerColor)
                .foregroundColor(.white)
                .cornerRadius(8)

            Triangle()
                .fill(markerColor)
                .frame(width: 10, height: 8)
        }
    }

    private var markerColor: Color {
        // Cor baseada no preço (heatmap)
        switch precoUnitario {
        case 0..<5000: return .blue
        case 5000..<7000: return .green
        case 7000..<9000: return .yellow
        case 9000..<11000: return .orange
        default: return .red
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubPath()
        return path
    }
}
```

---

## 🌐 Serviço de API Externa

### APIService

```swift
// Core/Network/APIService.swift
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Erro ao processar resposta: \(error.localizedDescription)"
        case .serverError(let code):
            return "Erro do servidor: \(code)"
        case .unauthorized:
            return "Não autorizado"
        }
    }
}

class APIService {
    static let shared = APIService()

    private let baseURL: String
    private let session: URLSession

    init() {
        // Carregar da configuração (Info.plist ou Config)
        #if DEBUG
        self.baseURL = "https://sua-api-teste.com"
        #else
        self.baseURL = "https://sua-api-producao.com"
        #endif

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
    }

    // MARK: - Inferência de Preço (ML)

    func inferirPrecoImovel(
        cidade: String,
        latitude: Double,
        longitude: Double,
        area: Double,
        quartos: Int,
        banheiros: Int,
        garagem: Int,
        idadeImovel: Int,
        qualidadeImovel: Int,
        tipo: String
    ) async throws -> PrecificacaoImovel {
        let endpoint = "/api/inferencia-preco"

        let body: [String: Any] = [
            "cidade": cidade,
            "latitude": latitude,
            "longitude": longitude,
            "area": area,
            "quartos": quartos,
            "banheiros": banheiros,
            "garagem": garagem,
            "idade_imovel": idadeImovel,
            "qualidade_imovel": qualidadeImovel,
            "tipo": tipo
        ]

        return try await post(endpoint: endpoint, body: body)
    }

    // MARK: - Assistente IA

    func enviarMensagem(mensagem: String, historico: [MensagemChat]) async throws -> RespostaAssistente {
        let endpoint = "/api/assistente-ia"

        let body: [String: Any] = [
            "mensagem": mensagem,
            "historico": historico.map { $0.toDictionary() }
        ]

        return try await post(endpoint: endpoint, body: body)
    }

    func carregarHistorico(usuarioId: String) async throws -> [MensagemChat] {
        let endpoint = "/api/historico/\(usuarioId)"
        return try await get(endpoint: endpoint)
    }

    // MARK: - Generic HTTP Methods

    private func get<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "", code: -1))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    private func post<T: Decodable>(endpoint: String, body: [String: Any]) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "", code: -1))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

// Modelos de resposta
struct RespostaAssistente: Codable {
    let resposta: String
    let timestamp: Date
}

struct MensagemChat: Codable, Identifiable {
    let id: UUID
    let texto: String
    let isUsuario: Bool
    let timestamp: Date

    func toDictionary() -> [String: Any] {
        return [
            "texto": texto,
            "is_usuario": isUsuario,
            "timestamp": timestamp.timeIntervalSince1970
        ]
    }
}
```

---

## 🧪 Testes Unitários (Exemplo)

### FirestoreServiceTests

```swift
// BuidUpMobileTests/FirestoreServiceTests.swift
import XCTest
@testable import BuidUpMobile

final class FirestoreServiceTests: XCTestCase {
    var firestoreService: FirestoreService!

    override func setUp() {
        super.setUp()
        firestoreService = FirestoreService.shared
    }

    override func tearDown() {
        firestoreService = nil
        super.tearDown()
    }

    func testFetchProjetos() async throws {
        // Given

        // When
        let projetos = try await firestoreService.fetchProjetos()

        // Then
        XCTAssertNotNil(projetos)
        XCTAssertGreaterThan(projetos.count, 0)
    }

    func testFetchProjetoById() async throws {
        // Given
        let projetoId = "test-project-id"

        // When
        let projeto = try await firestoreService.fetchProjeto(id: projetoId)

        // Then
        XCTAssertEqual(projeto.id, projetoId)
        XCTAssertNotNil(projeto.nomeProjeto)
    }

    func testFormatarComoMoeda() {
        // Given
        let valor1: Double = 1_500_000
        let valor2: Double = 750_000

        // When
        let formatado1 = valor1.formatarComoMoeda()
        let formatado2 = valor2.formatarComoMoeda()

        // Then
        XCTAssertEqual(formatado1, "R$ 1.50M")
        XCTAssertTrue(formatado2.contains("R$"))
    }
}
```

---

## 🎨 Design System (Cores e Estilos)

### Colors+Extensions

```swift
// Core/Extensions/Color+Extensions.swift
import SwiftUI

extension Color {
    // Cores do BuidUp
    static let buidupPrimary = Color("PrimaryColor")      // Azul principal
    static let buidupSecondary = Color("SecondaryColor")  // Verde
    static let buidupAccent = Color("AccentColor")        // Laranja

    // Cores de viabilidade
    static let viabilidadeExcelente = Color.green
    static let viabilidadeBoa = Color.blue
    static let viabilidadeBaixa = Color.orange
    static let viabilidadeInviavel = Color.red

    // Cores de background
    static let backgroundPrimary = Color(.systemBackground)
    static let backgroundSecondary = Color(.secondarySystemBackground)
    static let backgroundTertiary = Color(.tertiarySystemBackground)
}
```

### Constants

```swift
// Shared/Utils/Constants.swift
import Foundation

struct Constants {
    // Firebase
    static let colecaoFirestore = "estudos_viabilidade"

    // Critérios de Viabilidade
    static let margemMinimaViabilidade: Double = 16.0

    // Formatação
    static let casasDecimaisIndices = 4
    static let casasDecimaisPercentuais = 2
    static let casasDecimaisAreas = 2

    // Limites
    static let maxSolucoesExibidas = 100
    static let maxImagensProjeto = 10

    // API
    #if DEBUG
    static let apiBaseURL = "https://sua-api-teste.com"
    #else
    static let apiBaseURL = "https://sua-api-producao.com"
    #endif
}
```

---

## 🚀 Roadmap de Desenvolvimento

### Fase 1: Setup e Autenticação (Semana 1-2)
- ✅ Criar projeto Xcode
- ✅ Configurar Firebase (Auth + Firestore)
- ✅ Implementar login/registro
- ✅ Estruturar pastas (MVVM)
- ✅ Criar modelos base (Projeto, Análises)

### Fase 2: Listagem de Projetos (Semana 3)
- ✅ Tela de listagem de projetos
- ✅ Buscar projetos do Firestore
- ✅ Tela de detalhes do projeto
- ✅ Navegação entre telas

### Fase 3: Análise de Viabilidade (Semana 4-5)
- ✅ Carregar análise de viabilidade
- ✅ Exibir métricas gerais
- ✅ Lista de soluções viáveis
- ✅ Filtros (tipologia, margem)
- ✅ Detalhes de solução individual
- ✅ Gráficos (pie, bar, histogram)

### Fase 4: Análise de Mercado (Semana 6-7)
- ✅ Carregar análise de mercado
- ✅ Exibir estatísticas de preços
- ✅ Mapa de pontos (MapKit)
- ✅ Gráficos de distribuição
- ✅ Inferência de preço (API ML)

### Fase 5: Análise de Terreno (Semana 8)
- ✅ Carregar análise de terreno
- ✅ Exibir estatísticas gerais
- ✅ Estatísticas por bairro
- ✅ Precificação de terreno
- ✅ Edição de parecer

### Fase 6: Assistente IA (Semana 9)
- ✅ Interface de chat
- ✅ Integração com API
- ✅ Histórico de mensagens
- ✅ Navegador de normas

### Fase 7: Polimento e Testes (Semana 10-11)
- ✅ Testes unitários
- ✅ Tratamento de erros
- ✅ Loading states
- ✅ Empty states
- ✅ Acessibilidade
- ✅ Dark mode

### Fase 8: Deploy (Semana 12)
- ✅ TestFlight
- ✅ App Store submission
- ✅ Documentação final

---

## 📱 Funcionalidades Mobile-Specific

### Notificações Push
```swift
// Notificar quando nova análise é adicionada
// Notificar quando parecer é atualizado
```

### Compartilhamento
```swift
// Compartilhar relatório de viabilidade (PDF)
// Compartilhar gráficos (imagens)
```

### Modo Offline
```swift
// Cache local com Firebase Offline Persistence
// Sincronização automática ao voltar online
```

### Face ID / Touch ID
```swift
// Autenticação biométrica
import LocalAuthentication
```

---

## 🐛 Troubleshooting Comum

### Problema 1: Firebase não inicializa
**Solução:** Verificar se `GoogleService-Info.plist` está no bundle.

### Problema 2: Erro de decodificação JSON
**Solução:** Verificar `CodingKeys` e tipos de dados (snake_case vs camelCase).

### Problema 3: Mapas não aparecem
**Solução:** Adicionar permissão de localização no `Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Precisamos de sua localização para exibir imóveis no mapa</string>
```

### Problema 4: Gráficos não renderizam
**Solução:** Verificar se iOS 16+ está configurado ou usar biblioteca alternativa (DGCharts).

---

## 📚 Recursos Úteis

### Documentação
- [SwiftUI](https://developer.apple.com/documentation/swiftui)
- [Firebase iOS](https://firebase.google.com/docs/ios/setup)
- [Swift Charts](https://developer.apple.com/documentation/charts)
- [MapKit](https://developer.apple.com/documentation/mapkit)

### Bibliotecas Recomendadas
- **Kingfisher**: Cache de imagens
- **Lottie**: Animações
- **SwiftLint**: Linting de código
- **DGCharts**: Gráficos avançados (alternativa ao Swift Charts)

---

## 🤝 Compatibilidade com Sistema Web

### Mesma Base de Dados
- ✅ Firebase Firestore compartilhado
- ✅ Mesma estrutura de coleções/subcoleções
- ✅ Mesmos endpoints de API

### Sincronização em Tempo Real
- ✅ Atualizações do web refletem no mobile (via Firestore listeners)
- ✅ Edições no mobile aparecem no web

### Autenticação Unificada
- ✅ Mesmo Firebase Auth
- ✅ Login no mobile = login no web

---

## ✅ Checklist de Qualidade

### Antes de Fazer Commit
- [ ] Código compila sem warnings
- [ ] Testes unitários passam
- [ ] Tratamento de erros implementado
- [ ] Loading/Empty states adicionados
- [ ] Strings localizadas (pt-BR)
- [ ] Dark mode suportado
- [ ] Acessibilidade (VoiceOver)

### Antes de Submeter para Revisão
- [ ] Código revisado (self-review)
- [ ] Comentários adicionados onde necessário
- [ ] Performance otimizada
- [ ] Memory leaks verificados (Instruments)
- [ ] Testes manuais completos
- [ ] Screenshots/vídeos atualizados

---

## 🎯 Boas Práticas

### Arquitetura MVVM
```swift
// ✅ BOM
// View → ViewModel → Model/Service
// View só observa ViewModel (@Published)
// ViewModel contém lógica de negócio
// Service/Repository acessa dados externos

// ❌ RUIM
// View acessa Firestore diretamente
// Lógica de negócio na View
```

### Async/Await
```swift
// ✅ BOM
func loadData() async {
    isLoading = true
    do {
        data = try await service.fetch()
    } catch {
        errorMessage = error.localizedDescription
    }
    isLoading = false
}

// ❌ RUIM (callbacks aninhados)
```

### SwiftUI State Management
```swift
// ✅ BOM
@StateObject var viewModel: MyViewModel  // Owner
@ObservedObject var viewModel: MyViewModel  // Passado
@EnvironmentObject var auth: AuthViewModel  // Global

// ❌ RUIM
@State var viewModel: MyViewModel  // Recria toda vez
```

---

Boa sorte com o desenvolvimento do BuidUp Mobile! 🚀

Para dúvidas, consulte a documentação ou entre em contato com a equipe.
