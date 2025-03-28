--pergunta 1
SELECT COUNT(*) 
FROM `datario.adm_central_atendimento_1746.chamado` 
WHERE DATE(data_inicio) = "2023-04-01"; 
--Respota: 1903

--pergunta 2
SELECT categoria, COUNT(*) AS total_chamados 
FROM `datario.adm_central_atendimento_1746.chamado` 
WHERE DATE(data_inicio) = "2023-04-01"
GROUP BY categoria
ORDER BY total_chamados DESC; 
--respota: serviço:1756

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

--pergunta 6
SELECT subtipo , COUNT(*) AS total_chamados 
FROM `datario.adm_central_atendimento_1746.chamado` 
WHERE DATE(data_particao) BETWEEN "2022-01-01" AND "2023-12-31" 
--AND subtipo = 'Perturbação do sossego'
GROUP BY subtipo
ORDER BY total_chamados DESC; 
/* A query acima retorna todos os subtipos e o total de chamadas para cada. Verificamos que não existe o subtipo"Perturbação do sossego", mas sim "Fiscalização de perturbação do sossego". Assim, podemos aplicar o filtro correto, tendo portanto:*/
SELECT subtipo , COUNT(*) AS total_chamados 
FROM `datario.adm_central_atendimento_1746.chamado` 
WHERE DATE(data_particao) BETWEEN "2022-01-01" AND "2023-12-31" 
AND subtipo = 'Fiscalização de perturbação do sossego'
GROUP BY subtipo
ORDER BY total_chamados DESC; 
-- Resposta: Fiscalização de perturbação do sossego : 50368

--pergunta 7
SELECT subtipo , COUNT(*) AS total_chamados 
FROM `datario.adm_central_atendimento_1746.chamado` chamado 
JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` evento
ON chamado.data_inicio BETWEEN evento.data_inicial AND evento.data_final
WHERE chamado.subtipo = 'Fiscalização de perturbação do sossego'
GROUP BY chamado.subtipo
ORDER BY total_chamados DESC; 
--Resposta: 896
--pergunta 8
SELECT turismo.evento , COUNT(*) AS total_chamados 
FROM `datario.adm_central_atendimento_1746.chamado` chamado 
JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` turismo
ON chamado.data_inicio BETWEEN turismo.data_inicial AND turismo.data_final
WHERE chamado.subtipo = 'Fiscalização de perturbação do sossego'
GROUP BY turismo.evento
ORDER BY total_chamados DESC; 
--reposta: Rock in Rio:602 ; Carnaval:206 ; Réveillon:88;
--pergunta 9
SELECT turismo.evento, 
       COUNT(*) AS total_chamados, 
       COUNT(*) / (DATE_DIFF(turismo.data_final, turismo.data_inicial, DAY) + 1) AS media_diaria
FROM `datario.adm_central_atendimento_1746.chamado` chamado 
JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` turismo
ON chamado.data_inicio BETWEEN turismo.data_inicial AND turismo.data_final
WHERE chamado.subtipo = 'Fiscalização de perturbação do sossego'
GROUP BY turismo.evento, turismo.data_inicial, turismo.data_final
ORDER BY media_diaria DESC;
--respota: rock in rio
--pergunta 10:
WITH eventos_especificos AS (
  SELECT 
    turismo.evento, 
    COUNT(*) AS total_chamados, 
    COUNT(*) / (DATE_DIFF(MAX(turismo.data_final), MIN(turismo.data_inicial), DAY) + 1) AS media_diaria
  FROM `datario.adm_central_atendimento_1746.chamado` chamado
  JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` turismo
  ON chamado.data_inicio BETWEEN turismo.data_inicial AND turismo.data_final
  WHERE chamado.subtipo = 'Fiscalização de perturbação do sossego'
  AND turismo.evento IN ('Reveillon', 'Carnaval', 'Rock in Rio')
  GROUP BY turismo.evento
),

media_geral AS (
  SELECT 
    COUNT(*) AS total_chamados,
    COUNT(*) / (DATE_DIFF(DATE '2023-12-31', DATE '2022-01-01', DAY) + 1) AS media_diaria
  FROM `datario.adm_central_atendimento_1746.chamado`
  WHERE subtipo = 'Fiscalização de perturbação do sossego'
  AND DATE(data_particao) BETWEEN '2022-01-01' AND '2023-12-31'
)

SELECT * FROM eventos_especificos
UNION ALL
SELECT 'Média Geral' AS evento, total_chamados, media_diaria FROM media_geral
ORDER BY media_diaria DESC;
-- a média diária geral é de 68 chamados, e a média em dia de eventos é levemente inferior, com 60 para o rock in rio e 51 para o carnaval
