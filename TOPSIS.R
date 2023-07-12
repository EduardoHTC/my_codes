#TOPSIS (Technique for Order Preference by Similarity to Ideal Solution)
#Code created by: Eduardo HTC
#Date: 18/02/2023

#-----INFORMACOES DE ENTRADA-----

#dados de entrada
data_file = NSGA_results
topsis_data = data_file[,c('mix','DP')]
#pesos das variaveis
topsis_w = c(0.7, 0.3)
# (+) -> maximizacao | (-) -> minimizacao da variavel
topsis_bnfts = c('+','-')

#-----PROGRAMA EM ACAO-----

#normalizacao(escalonamento) dos dados
#valores elevados ao quadrado
sqrd_values = matrix(nrow = nrow(topsis_data), ncol = ncol(topsis_data))
for (i in 1:nrow(topsis_data)){
  for (j in 1:ncol(topsis_data)){
    sqrd_values[i,j] = topsis_data[i,j]^2
  }
}
#soma dos valores
summ = vector(length = ncol(topsis_data))
for (j in 1:ncol(sqrd_values)){
  summ[j] = sum(sqrd_values[,j])
}
#NORMALIZACAO DOS DADOS
topsis_data_scaled = matrix(nrow = nrow(topsis_data), ncol = ncol(topsis_data))
for (i in 1:nrow(topsis_data)){
  for (j in 1:ncol(topsis_data)){
    topsis_data_scaled[i,j] = topsis_data[i,j]/sqrt(summ[j])
  }
}
#matriz de decisao normalizada
topsis_data_w = matrix(nrow = nrow(topsis_data), ncol = ncol(topsis_data))
for (i in 1:nrow(topsis_data_scaled)){
  for (j in 1:ncol(topsis_data_scaled)){
    topsis_data_w[i,j] = topsis_w[j]*topsis_data_scaled[i,j]
  }
}
#solucoes ideais e nao-ideais
best_value = vector(length = ncol(topsis_data_w))
worst_value = vector(length = ncol(topsis_data_w))
for (j in 1:ncol(topsis_data_w)){
  if (topsis_bnfts[j] == '+'){
    best_value[j] = max(topsis_data_w[,j])
    worst_value[j] = min(topsis_data_w[,j])
  }else if (topsis_bnfts[j] == '-'){
    best_value[j] = min(topsis_data_w[,j])
    worst_value[j] = max(topsis_data_w[,j])
  }
}
best_value = t(data.frame(best_value))
worst_value = t(data.frame(worst_value))
#distancias euclidianas = medidas de separacao
diff_plus = matrix(nrow = nrow(topsis_data_w), ncol = ncol(topsis_data_w))
diff_mins = matrix(nrow = nrow(topsis_data_w), ncol = ncol(topsis_data_w))
for (i in 1:nrow(topsis_data_w)){
  for (j in 1:ncol(topsis_data_w)){
    diff_plus[i,j] = (topsis_data_w[i,j]-best_value[j])^2
    diff_mins[i,j] = (topsis_data_w[i,j]-worst_value[j])^2
  }
}
dplus = vector(length = length(nrow(topsis_data_w)))
dmins = vector(length = length(nrow(topsis_data_w)))
for (i in 1:nrow(topsis_data_w)){
  dplus[i] = sqrt(sum(diff_plus[i,]))
  dmins[i] = sqrt(sum(diff_mins[i,]))
}
#medida de similaridade(C+)
cplus = vector(length = length(nrow(topsis_data_w)))
for (i in 1:nrow(topsis_data_w)){
  cplus[i] = dmins[i]/(dplus[i]+dmins[i])
}
#mostrar resultados
cplus = cbind(cplus,rank(-cplus))

plot(topsis_data, main = 'TOPSIS decision')
points(x = max(topsis_data[,1]), y = min(topsis_data[,2]), col = 'green', pch = 19)
points(x = min(topsis_data[,1]), y = max(topsis_data[,2]), col = 'red', pch = 19)
points(x = topsis_data[which(cplus[,2]==1),1], y = topsis_data[which(cplus[,2]==1),2], col = 'blue', pch = 19)

print(data_file[which(cplus[,2]==1),])
