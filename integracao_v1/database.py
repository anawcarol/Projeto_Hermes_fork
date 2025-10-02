import sqlite3
from collections import defaultdict

def carregar_dados_bd(caminho_bd):
    conn = sqlite3.connect(caminho_bd)
    cursor = conn.cursor()
    
    paradas = []
    linhas_de_onibus = defaultdict(list)
    
    cursor.execute('SELECT id_ponto_parada, linhas FROM tab_linha_parada')
    for row in cursor.fetchall():
        id_ponto_parada = row[0]
        linhas_str = row[1]
        
        if linhas_str:  # só divide se não for None ou vazio
            linhas = linhas_str.split(', ')
            linhas_de_onibus[id_ponto_parada].extend(linhas)
        
        paradas.append(id_ponto_parada)
    
    conn.close()
    return paradas, linhas_de_onibus
