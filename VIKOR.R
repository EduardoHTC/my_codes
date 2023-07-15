#VIKOR (Visekriterijumska Optimizacija Kompromisno Resenje)
#Authors: Opricovic e Tseng (2004)
#Code created by: Eduardo HTC
#Date: 17/02/2023

#-------INFORMACOES DE ENTRADA-------

#arquivo de dados
#vikor_data = as.data.frame(vikor_data)
#definicao dos pesos de cada variavel -> a soma dos pesos deve ser = 1
vikor_w = c(0.7,0.3)
bnfts = c('+','-')
#peso VIKOR (valor entre 0 e 1) -> 0.5 é bom (confia)
#v = (nrow(vikor_data)+1)/(nrow(vikor_data)*2)
v = 0.5
data_file = NSGA_results
vikor_data = data_file[,c('mix','DP')]

#-------PROGRAMA EM ACAO-------

#valores elevados ao quadrado
sqrd_values = matrix(nrow = nrow(vikor_data), ncol = ncol(vikor_data))
for (i in 1:nrow(vikor_data)){
  for (j in 1:ncol(vikor_data)){
    sqrd_values[i,j] = vikor_data[i,j]^2
  }
}
#soma dos valores
summ = vector(length = ncol(vikor_data))
for (j in 1:ncol(sqrd_values)){
  summ[j] = sum(sqrd_values[,j])
}
#NORMALIZACAO DOS DADOS
vikor_data_scaled = matrix(nrow = nrow(vikor_data), ncol = ncol(vikor_data))
for (i in 1:nrow(vikor_data)){
  for (j in 1:ncol(vikor_data)){
    vikor_data_scaled[i,j] = vikor_data[i,j]/sqrt(summ[j])
  }
}
#achando o maximo e minimo de cada caso
best_value = vector(length = ncol(vikor_data_scaled))
worst_value = vector(length = ncol(vikor_data_scaled))
for (j in 1:ncol(vikor_data_scaled)){
  if (bnfts[j] == '+'){
    best_value[j] = max(vikor_data_scaled[,j])
    worst_value[j] = min(vikor_data_scaled[,j])
  }else if (bnfts[j] == '-'){
    best_value[j] = min(vikor_data_scaled[,j])
    worst_value[j] = max(vikor_data_scaled[,j])
  }
}

# UTILITY MEASURE (S+ AND S-)
#+--++-+
u_matrix = matrix(nrow = nrow(vikor_data_scaled), ncol = ncol(vikor_data_scaled))
for (i in 1:nrow(vikor_data_scaled)){
  for (j in 1:ncol(vikor_data_scaled))
      u_matrix[i,j] = vikor_w[j]*((best_value[j]-vikor_data_scaled[i,j])/(best_value[j]-worst_value[j]))
}
#Si calculation
Si = vector(length = nrow(u_matrix))
for (i in 1:nrow(u_matrix)){
  Si[i] = sum(u_matrix[i,])
}
Si_max = max(Si)
Si_min = min(Si)

#Ri calculation
Ri = vector(length = nrow(u_matrix))
for (i in 1:nrow(u_matrix)){
  Ri[i] = max(u_matrix[i,])
}
Ri_max = max(Ri)
Ri_min = min(Ri)

#Qi calculation
Qi = vector(length = nrow(u_matrix))
for (i in 1:nrow(u_matrix)){
  Qi[i] = (v*((Si[i]-Si_min)/(Si_max-Si_min)))+((1-v)*((Ri[i]-Ri_min)/(Ri_max-Ri_min)))
}
Qi_final_results = rbind(Qi,rank(Qi))
Qi_final_results = t(Qi_final_results)

#Solution conditions
DQ = 1/(nrow(vikor_data)-1)
closeness = vector(length = nrow(Qi_final_results)) 
for (i in 1:nrow(Qi_final_results)){
 closeness[i] = Qi_final_results[i,1]-Qi_final_results[which(Qi_final_results[,2]==1),1]
}
closeness = t(rbind(closeness,rank(closeness)))
#C1 = acceptable advantage | C2 = stability | C3 = closeness
for (i in 1:nrow(Qi_final_results)){
 if (Qi_final_results[which(Qi_final_results[,2]==2),1]-Qi_final_results[which(Qi_final_results[,2]==1),1]>=DQ & Si[i] == min(Si) & Ri[i] == min(Ri)){ 
   #solution = vikor_data[which(Qi_final_results[,2]==1),]
   solution = which.min(Qi_final_results)
 } else if(Qi_final_results[which(Qi_final_results[,2]==2),1]-Qi_final_results[which(Qi_final_results[,2]==1),1]<DQ & Si[i] == min(Si) & Ri[i] == min(Ri)){
   solution = c(which(Qi_final_results[,2]==1, Qi_final_results[,2]==2))
   } else{
   solution = which(closeness<DQ)
 }
}
# #mostrar resultados
DP = vector(length = length(solution))
for (i in 1:length(solution)){
 DP[i] = vikor_data[solution[i],2]/vikor_data[solution[i],1]
}
print(DP)

solution = which.min(Qi_final_results)
print(data_file[solution,])

plot(vikor_data, main = 'VIKOR decision')
points(x = max(vikor_data[,1]), y = min(vikor_data[,2]), col = 'green', pch = 19)
points(x = min(vikor_data[,1]), y = max(vikor_data[,2]), col = 'red', pch = 19)
points(x = vikor_data[which(Qi_final_results[,2]==1),1], y = vikor_data[which(Qi_final_results[,2]==1),2], col = 'blue', pch = 19)

vikor_decision = write.csv(data_file[solution,], file = 'vikor_decision.csv')


