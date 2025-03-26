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
