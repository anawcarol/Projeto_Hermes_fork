from database import carregar_dados_com_sequencia_postgres
from graph import construir_grafo_completo, aplicar_direcionalidade
from a_star import encontrar_caminho_com_integracao_astar, encontrar_linha_mais_direta, formatar_caminho
from utils import salvar_grafo, carregar_grafo
import time

def main():
    caminho_arquivo_grafo = 'grafo.pkl'
    
    print("=" * 60)
    print("🚀 SISTEMA DE BUSCA DE ROTAS DE ÔNIBUS")
    print("=" * 60)
    
    # Tenta carregar grafo existente
    print("📂 Carregando grafo...")
    grafo = carregar_grafo(caminho_arquivo_grafo)
    
    # SEMPRE carrega as sequências para análise de linhas diretas
    print("🗃️  Carregando sequências do banco...")
    paradas, linhas_por_parada, sequencias, linhas_info = carregar_dados_com_sequencia_postgres()
    
    if grafo is None:
        print("🔄 Construindo novo grafo direcional...")
        start_time = time.time()
        
        if not paradas:
            print("❌ Erro: Não foi possível carregar dados do banco.")
            return
        
        # Constrói o grafo
        grafo_completo = construir_grafo_completo(paradas, linhas_por_parada)
        grafo = aplicar_direcionalidade(grafo_completo, sequencias)
        
        # Salva para uso futuro
        salvar_grafo(grafo, caminho_arquivo_grafo)
        
        end_time = time.time()
        print(f"✅ Grafo criado em {end_time - start_time:.2f} segundos")
    else:
        print("✅ Grafo carregado do arquivo")
    
    print("\n" + "=" * 60)
    print("📍 SISTEMA PRONTO PARA BUSCAS")
    print("=" * 60)
    
    # Interface de busca
    while True:
        try:
            print("\n" + "-" * 40)
            origem = int(input("Digite a parada de origem: "))
            destino = int(input("Digite a parada de destino: "))
            
            # Verificações básicas
            if origem not in grafo:
                print(f"❌ Parada {origem} não encontrada.")
                continue
            if destino not in grafo:
                print(f"❌ Parada {destino} não encontrada.")
                continue
            if origem == destino:
                print("❌ Origem e destino iguais.")
                continue
            
            # Verifica linha direta ANTES da busca
            print("🔍 Analisando linhas diretas...")
            linha_direta, num_paradas = encontrar_linha_mais_direta(grafo, sequencias, origem, destino)
            
            if linha_direta:
                print(f"✅ LINHA DIRETA: {linha_direta} ({num_paradas} paradas)")
            else:
                print("ℹ️  Nenhuma linha direta encontrada")
            
            # Busca o caminho completo
            print("🔄 Buscando melhor rota...")
            start_time = time.time()
            caminho = encontrar_caminho_com_integracao_astar(grafo, origem, destino)
            end_time = time.time()
            
            if caminho:
                print(f"\n✅ ROTA ENCONTRADA ({end_time - start_time:.2f}s)")
                print("=" * 50)
                print(formatar_caminho(caminho))
                print("=" * 50)
                
                # Estatísticas
                total_trechos = (len(caminho) - 1) // 2
                print(f"\n📊 Estatísticas:")
                print(f"   • Trechos: {total_trechos}")
                print(f"   • Paradas totais: {len([x for x in caminho if isinstance(x, int)])}")
                
            else:
                print("\n❌ Nenhum caminho encontrado")
                
        except ValueError:
            print("❌ Digite apenas números")
        except KeyboardInterrupt:
            print("\n👋 Saindo...")
            break

if __name__ == "__main__":
    main()