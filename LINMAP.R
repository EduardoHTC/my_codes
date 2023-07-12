#LINMAP (Linear programming technique for multidimensional analysis of preference)
#Code created by: Eduardo HTC
#Date: 19/02/2023

#-----INFORMACOES DE ENTRADA-----

#dados de entrada
#linmap_data = topsis_data
#linmap_data = as.data.frame(linmap_data)
# (+) -> maximizacao | (-) -> minimizacao da variavel
data_file = NSGA_results
linmap_data = data_file[,c('mix','DP')]
linmap_bnfts = c('+','-')

#-----PROGRAMA EM ACAO-----

#normalizacao(escalonamento) dos dados
linmap_data_scaled = scale(linmap_data)
#solucoes ideais e nao-ideais
best_value = vector(length = ncol(linmap_data_scaled))
for (j in 1:ncol(linmap_data_scaled)){
  if (linmap_bnfts[j] == '+'){
    best_value[j] = max(linmap_data_scaled[,j])
  }else if (linmap_bnfts[j] == '-'){
    best_value[j] = min(linmap_data_scaled[,j])
  }
}
best_value = t(data.frame(best_value))
#distancias euclidianas = medidas de separacao
diff_plus = matrix(nrow = nrow(linmap_data_scaled), ncol = ncol(linmap_data_scaled))
for (i in 1:nrow(linmap_data_scaled)){
  for (j in 1:ncol(linmap_data_scaled)){
    diff_plus[i,j] = ((linmap_data_scaled[i,1]-best_value[j])+(linmap_data_scaled[j,2]-best_value[j]))^2
  }
}
dplus = vector(length = length(nrow(linmap_data_scaled)))
for (i in 1:nrow(linmap_data_scaled)){
  dplus[i] = sqrt(sum(diff_plus[i,]))
}
#mostrar resultados
dplus = cbind(dplus,rank(dplus))

plot(linmap_data, main ='LINMAP decision')
points(x = max(linmap_data[,1]), y = min(linmap_data[,2]), col = 'green', pch = 19)
points(x = linmap_data[which(dplus[,2]==1),1], y = linmap_data[which(dplus[,2]==1),2], col = 'blue', pch = 19)

print(data_file[which(dplus[,2]==1),])
linmap_decision = write.csv(data_file[which(dplus[,2]==1),], file = 'linmap_decision.csv')


