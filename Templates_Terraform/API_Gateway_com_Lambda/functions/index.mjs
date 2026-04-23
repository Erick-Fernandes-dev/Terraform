export const handler = async (event) => {
  console.log("Evento recebido:", JSON.stringify(event, null, 2));

  let nome = "Visitante";

  try {
      // 1. Tenta pegar o nome via Query String (ex: api.com/test?nome=Junior)
      if (event.queryStringParameters && event.queryStringParameters.nome) {
          nome = event.queryStringParameters.nome;
      } 
      // 2. Tenta pegar o nome via Body (POST)
      else if (event.body) {
          const body = JSON.parse(event.body);
          nome = body.nome || nome;
      }
  } catch (error) {
      console.error("Erro ao processar input:", error);
  }

  const response = {
      statusCode: 200,
      headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*" // Importante para evitar erros de CORS
      },
      body: JSON.stringify({
          mensagem: `Olá, ${nome}! Função executada com sucesso.`,
          timestamp: new Date().toISOString()
      }),
  };

  return response;
};