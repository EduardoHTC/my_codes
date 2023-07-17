#CONSTRUCAO DO METODO CENTRAL COMPOSITE DESIGN PARA EXPERIMENTOS COM TRES GRAUS DE LIBERDADE
#PARA PADRONIZAR O CODIGO, DEFINE-SE AS VARIAVEIS 'var1','var2','var3','var41 e 'var5' COMO OS GRAUS DE LIBERDADE 
#DO PROBLEMA

#Comando para carregar a biblioteca rsm, a qual contem a funcao ccd, necessaria para criacao do modelo
library(rsm)

#=====DEFINIR A PASTA PARA SALVARA PLANILHA DE RESULTADOS=====
#No parentesis da funcao setwd, coloca-se o diretorio da pasta na qual se deseja salvar o arquivo de resultado do CCD
#setwd("c:/Documents/my/working/directory")

#=====DEFINIR OS LIMITES SUPERIOR E INFERIOR DE CADA VARIAVEL PARA O CONJUNTO DE PONTOS=====
#Aqui deve-se modificar os valores que correspondem aos limites de cada variavel do problema
lim_sup_var1 = 0.10
lim_inf_var1 = 0.02
lim_sup_var2 = 0.10
lim_inf_var2 = 0.02
lim_sup_var3 = 0.10
lim_inf_var3 = 0.02
lim_sup_var4 = 0.10
lim_inf_var4 = 0.02
lim_sup_var5 = 0.10
lim_inf_var5 = 0.02
#=====DEFINICAO DOS PARAMETROS NECESSARIOS PARA APLICACAO DO METODO CCD=====
#Aqui, nao ha necessidade de modificacao no codigo
CP_var1 = (lim_sup_var1+lim_inf_var1)*0.5
CP_var2 = (lim_sup_var2+lim_inf_var2)*0.5
CP_var3 = (lim_sup_var3+lim_inf_var3)*0.5
CP_var4 = (lim_sup_var4+lim_inf_var4)*0.5
CP_var5 = (lim_sup_var5+lim_inf_var5)*0.5
Range_var1 = (lim_sup_var1-CP_var1)/(0.5*sqrt(5))
Range_var2 = (lim_sup_var2-CP_var2)/(0.5*sqrt(5))
Range_var3 = (lim_sup_var3-CP_var3)/(0.5*sqrt(5))
Range_var4 = (lim_sup_var4-CP_var4)/(0.5*sqrt(5))
Range_var5 = (lim_sup_var5-CP_var5)/(0.5*sqrt(5))

#=====CRIACAO DO MODELO CCD=====
#Criando o DoE utilizando Central Composite Design
#A funcao ccd realiza o trabalho de criacao do modelo CCD. Nos parentesis, define-se alguns parametros extras.
#O numero 2 indica o numero de graus de liberdade. 
#n0 indica o numero de pontos centrais extras a serem a adicionados.
#Alpha refere-se ao modelo do ccd. Recomenda-se o modelo 'rotatable' - Conferir teoria do CCD 
#oneblock significa que os experimentos ser?o realizados em um bloco - Conferir teoria do DOE

#Para casos de dois graus de liberdade envolvendo simulacao numerica, os parametros abaixo estao de acordo
Modelo_CCD = ccd(5, n0 = 1, alpha = 'spherical', oneblock = TRUE)
View(Modelo_CCD)

#Adicionando as vari?veis naturais
Modelo_CCD$var1 = Modelo_CCD$x1*(0.5*Range_var1) + CP_var1
Modelo_CCD$var2 = Modelo_CCD$x2*(0.5*Range_var2) + CP_var2
Modelo_CCD$var3 = Modelo_CCD$x3*(0.5*Range_var3) + CP_var3
Modelo_CCD$var4 = Modelo_CCD$x4*(0.5*Range_var4) + CP_var4
Modelo_CCD$var5 = Modelo_CCD$x5*(0.5*Range_var5) + CP_var5

#Salvar o CCD em um arquivo
write.csv(Modelo_CCD, 'ccd_pontos_5dof.csv')