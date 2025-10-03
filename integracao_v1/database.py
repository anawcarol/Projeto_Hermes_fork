import psycopg2
import os
from collections import defaultdict

def carregar_dados_com_sequencia_postgres():
    """
    Carrega dados do PostgreSQL/PostGIS com a sequência correta das paradas
    """
    try:
        conn = psycopg2.connect(
            host=os.getenv('DB_HOST', '10.233.46.51'),
            port=os.getenv('DB_PORT', '5432'),
            database=os.getenv('DB_NAME', 'bdg'),
            user=os.getenv('DB_USER', 'ana_fialho'),
            password=os.getenv('DB_PASSWORD', 'Se654c$0')
        )
        
        cursor = conn.cursor()
        
        # Consulta para carregar linhas com sequência de paradas
        cursor.execute('''
            SELECT 
                cod_linha,
                sentido,
                paradas as array_paradas
            FROM linha_sentido_parada.tab_paradas_linhas_seq
            ORDER BY cod_linha, sentido
        ''')
        
        # Estruturas para armazenar os dados
        rotas_ordenadas = defaultdict(list)  # {linha_id: [(parada, sequencia)]}
        sequencias = {}                      # {linha_id: [parada1, parada2, ...]}
        linhas_info = {}                     # {linha_id: sentido}
        todas_paradas = set()
        linhas_por_parada = defaultdict(list) # {parada: [linha1, linha2, ...]}
        
        for cod_linha, sentido, array_paradas in cursor.fetchall():
            linha_id = f"{cod_linha}-{sentido}"
            linhas_info[linha_id] = sentido
            
            # Armazena a sequência ordenada de paradas
            sequencias[linha_id] = array_paradas
            
            # Processa o array de paradas com sua sequência
            for sequencia, parada in enumerate(array_paradas, 1):
                rotas_ordenadas[linha_id].append((parada, sequencia))
                todas_paradas.add(parada)
                linhas_por_parada[parada].append(linha_id)
        
        conn.close()
        print(f"📊 Carregadas {len(rotas_ordenadas)} linhas com {len(todas_paradas)} paradas únicas")
        return list(todas_paradas), linhas_por_parada, sequencias, linhas_info
        
    except Exception as e:
        print(f"❌ Erro na conexão com o banco: {e}")
        return [], defaultdict(list), {}, {}