# API GeoJSON para SQLite com Algoritmo A* para Busca Rápida Espacial

Este repositório oferece uma API de alta performance, desenvolvida com **FastAPI**, que converte dados **GeoJSON** em um banco de dados local **SQLite** e permite consultas rápidas de dados espaciais. A API suporta a busca de múltiplos `codDftrans` e retorna os resultados no formato **GeoJSON**, facilitando a integração com ferramentas de mapeamento.

### Principais Funcionalidades:
- **Busca Rápida**: Consultas otimizadas com SQLite garantem uma recuperação de dados geoespaciais de forma extremamente rápida, mesmo com grandes volumes de dados.
- **Implementação do Algoritmo A***: Inclui a implementação do algoritmo de busca A* (A-star) para calcular o caminho mais curto entre dois pontos geoespaciais, aprimorando a pesquisa e otimização de rotas.
- **Suporte a Múltiplas Consultas**: Permite a consulta de múltiplos pontos de parada ou locais geoespaciais ao mesmo tempo, retornando os resultados como uma `FeatureCollection` no formato GeoJSON.
- **Saída em GeoJSON**: Todos os dados são retornados no formato padrão GeoJSON, facilitando a integração com sistemas GIS ou aplicações de mapeamento.

Este projeto é ideal para sistemas de transporte, soluções de mapeamento ou qualquer aplicação que necessite de consultas geoespaciais rápidas e eficientes, combinadas com algoritmos poderosos de busca de rotas.