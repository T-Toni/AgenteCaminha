class Personagem {
  
  String id; // Identificador único para cada personagem (necessário para Firestore)
  String nome;
  String imagem;
  int posicao;
  bool checado; // Campo para indicar se o personagem foi selecionado

  int nivel;

  int vida;
  int dano;
  int velocidade;

  // Construtor com parâmetros obrigatórios para nome, imagem e posição
  Personagem({
    required this.id, // Adicionando o parâmetro 'id'
    required this.nome,
    required this.imagem,
    required this.posicao,
   
    this.vida = 0,
    this.dano = 0,
    this.velocidade = 0,
    
    this.nivel = 1,

    this.checado = false, // Campo 'checado' é opcional, por padrão será false
  });
}