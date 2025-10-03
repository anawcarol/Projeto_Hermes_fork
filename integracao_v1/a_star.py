import heapq

def heuristica(parada_atual, destino):
    """Função heurística simples"""
    return abs(parada_atual - destino) * 0.1

def encontrar_caminho_com_integracao_astar(grafo, origem, destino):
    """
    Função A* original - busca com custos fixos
    """
    fila = [(0, origem, [], None)]  # (custo_total, parada_atual, caminho, linha_anterior)
    visitados = set()
    melhores_custos = {origem: 0}

    while fila:
        custo, parada_atual, caminho, linha_anterior = heapq.heappop(fila)

        if parada_atual == destino:
            return caminho + [parada_atual]

        if parada_atual in visitados:
            continue
            
        visitados.add(parada_atual)

        if parada_atual not in grafo:
            continue

        for vizinho, linha in grafo[parada_atual]:
            if vizinho in visitados:
                continue
            
            # Custo fixo por movimento
            custo_movimento = 1
            
            # Penalidade por troca de linha
            if linha_anterior is not None and linha != linha_anterior:
                custo_movimento += 3
            
            novo_custo = custo + custo_movimento
            custo_estimado = novo_custo + heuristica(vizinho, destino)
            
            if vizinho not in melhores_custos or novo_custo < melhores_custos[vizinho]:
                melhores_custos[vizinho] = novo_custo
                
                if linha_anterior is None or linha != linha_anterior:
                    novo_caminho = caminho + [parada_atual, linha]
                else:
                    novo_caminho = caminho
                
                heapq.heappush(fila, (custo_estimado, vizinho, novo_caminho, linha))

    return None

def encontrar_linha_mais_direta(grafo, sequencias, origem, destino):
    """
    Encontra a linha que faz o caminho mais direto entre origem e destino
    Retorna (linha, num_paradas_intermediarias)
    """
    if origem not in grafo:
        return None, float('inf')
    
    melhor_linha = None
    menor_distancia = float('inf')
    
    # Verifica todas as conexões da origem
    for vizinho, linha in grafo[origem]:
        if linha not in sequencias:
            continue
            
        sequencia = sequencias[linha]
        
        # Verifica se ambas as paradas estão nessa linha
        if origem in sequencia and destino in sequencia:
            idx_origem = sequencia.index(origem)
            idx_destino = sequencia.index(destino)
            
            # Só considera se o destino está depois da origem
            if idx_destino > idx_origem:
                distancia = idx_destino - idx_origem
                if distancia < menor_distancia:
                    menor_distancia = distancia
                    melhor_linha = linha
    
    return melhor_linha, menor_distancia

def formatar_caminho(caminho):
    """
    Formata o caminho encontrado de maneira legível
    """
    if not caminho:
        return "Nenhum caminho encontrado"
    
    resultado = []
    
    # O caminho vem no formato: [parada, linha, parada, linha, ..., parada_final]
    for i in range(0, len(caminho) - 2, 2):
        parada_atual = caminho[i]
        linha = caminho[i + 1]
        prox_parada = caminho[i + 2]
        resultado.append(f"📍 Parada {parada_atual} → 🚌 {linha} → 📍 Parada {prox_parada}")
    
    # Conta trocas de linha
    trocas = 0
    if len(caminho) > 3:
        for i in range(3, len(caminho) - 1, 2):
            if caminho[i] != caminho[i-2]:
                trocas += 1
    
    if trocas > 0:
        resultado.append(f"\n🔄 Total de {trocas} troca(s) de linha")
    
    return "\n".join(resultado)