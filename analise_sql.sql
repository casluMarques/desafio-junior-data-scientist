--pergunta 1
SELECT COUNT(*) 
FROM `datario.adm_central_atendimento_1746.chamado` 
WHERE DATE(data_particao) = "2023-04-01"; 
--Respota: 78308

--pergunta 2
SELECT categoria, COUNT(*) AS total_chamados 
FROM `datario.adm_central_atendimento_1746.chamado` 
WHERE DATE(data_particao) = "2023-04-01"
GROUP BY categoria
ORDER BY total_chamados DESC; 
--respota: serviço:66970

--pergunta 3
SELECT bairro.nome, COUNT(*) AS total_chamados
FROM `datario.adm_central_atendimento_1746.chamado` chamado
JOIN `datario.dados_mestres.bairro` bairro
ON chamado.id_bairro = bairro.id_bairro
WHERE DATE(chamado.data_inicio) = '2023-04-01'
GROUP BY bairro.nome
ORDER BY total_chamados DESC;
--resposta: campo grande:124 ; tijuca:96 ; barra da tijuca:60

--pergunta 4
SELECT bairro.subprefeitura, COUNT(*) AS total_chamados
FROM `datario.adm_central_atendimento_1746.chamado` chamado
JOIN `datario.dados_mestres.bairro` bairro
ON chamado.id_bairro = bairro.id_bairro
WHERE DATE(chamado.data_inicio) = '2023-04-01'
GROUP BY bairro.subprefeitura
ORDER BY total_chamados DESC;
--respota: zona norte: 534

--pergunta 5
SELECT chamado.id_chamado, chamado.id_bairro
FROM `datario.adm_central_atendimento_1746.chamado` chamado
LEFT JOIN `datario.dados_mestres.bairro` bairro
ON chamado.id_bairro = bairro.id_bairro
WHERE DATE(chamado.data_inicio) = '2023-04-01'
AND bairro.id_bairro IS NULL;
/* resposta: sim, existem chamados que não estão associados a bairros. Isso provavelmente acontece na hora da coleta dos dados. O responsável pela transcirção do chamado para o sistema pode ter esquecido de preencher o dado
ou ainda, ter digitado errado e incluido um bairro ou id de bairro que não constam no sistema. */
