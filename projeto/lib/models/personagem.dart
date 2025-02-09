class Personagem {
  
  String id; // Identificador único para cada personagem (necessário para Firestore)
  String nome;
  String imagem;
  String classe;
  int posicao;
  bool checado; // Campo para indicar se o personagem foi selecionado

  int nivel;

  int vida;
  int danoMax;
  int danoMin;
  int velocidade;

  // Construtor com parâmetros obrigatórios para nome, imagem e posição
  Personagem({
    required this.id, // Adicionando o parâmetro 'id'
    required this.nome,
    required this.imagem,
    required this.classe,
    
    this.posicao = 0,
    this.vida = 0,
    this.danoMax = 0,
    this.danoMin = 0,
    this.velocidade = 0,
    
    this.nivel = 1,

    this.checado = false, // Campo 'checado' é opcional, por padrão será false
  });

  factory Personagem.fromJson(Map<String, dynamic> json) {
    return Personagem(
      id: json['id'] ?? '',
      nome: json['nome'],
      imagem: json['imagem'],
      classe: json['classe'],
      vida: json['vida'],
      danoMax: json['danoMax'],
      danoMin: json['danoMin'],
      velocidade: json['velocidade'],
    );
  }
}